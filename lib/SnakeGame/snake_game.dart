import 'dart:async';
import 'dart:math';
import 'package:fin_quest/SnakeGame/game_over.dart';
import 'package:flutter/material.dart';

class GamePage extends StatefulWidget {
  final String customerId;
  GamePage({required this.customerId, Key? key}) : super(key: key);
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> with TickerProviderStateMixin {
  late int _playerScore;
  late bool _hasStarted;
  late Animation _snakeAnimation;
  late AnimationController _snakeAnimationController;
  late List<int> _snake;
  final int _noOfSquares = 500;
  final Duration _duration = Duration(milliseconds: 250);
  final int _squareSize = 20;
  late String _currentSnakeDirection;
  late int _snakeFoodPosition;
  Random _random = Random();

  @override
  void initState() {
    super.initState();
    _setUpGame();
    _snakeAnimationController = AnimationController(
      vsync: this,
      duration: _duration,
    );
    _snakeAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _snakeAnimationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _snakeAnimationController.forward();
      }
    });
  }

  void _setUpGame() {
    _playerScore = 0;
    _currentSnakeDirection = 'RIGHT';
    _hasStarted = true;
    _snake = [404, 405, 406, 407];
    do {
      _snakeFoodPosition = _random.nextInt(_noOfSquares);
    } while (_snake.contains(_snakeFoodPosition));
  }

  void _gameStart() {
    Timer.periodic(Duration(milliseconds: 250), (Timer timer) {
      _updateSnake();
      if (_hasStarted) {
        timer.cancel();
        if (_snakeAnimationController.isAnimating) {
          _snakeAnimationController.reset();
        }
        return;
      }
      _snakeAnimationController.forward();
    });
  }

  bool _gameOver() {
    for (int i = 0; i < _snake.length - 1; i++) {
      if (_snake.last == _snake[i]) return true;
    }
    return false;
  }

  void _updateSnake() {
    if (!_hasStarted) {
      setState(() {
        _playerScore = (_snake.length - 4) * 100;
        switch (_currentSnakeDirection) {
          case 'DOWN':
            if (_snake.last > _noOfSquares) _snake.add(_snake.last + _squareSize - (_noOfSquares + _squareSize));
            else
              _snake.add(_snake.last + _squareSize);
            break;
          case 'UP':
            if (_snake.last < _squareSize) _snake.add(_snake.last - _squareSize + (_noOfSquares + _squareSize));
            else
              _snake.add(_snake.last - _squareSize);
            break;
          case 'RIGHT':
            if ((_snake.last + 1) % _squareSize == 0) _snake.add(_snake.last + 1 - _squareSize);
            else
              _snake.add(_snake.last + 1);
            break;
          case 'LEFT':
            if ((_snake.last) % _squareSize == 0) _snake.add(_snake.last - 1 + _squareSize);
            else
              _snake.add(_snake.last - 1);
        }

        if (_snake.last != _snakeFoodPosition) _snake.removeAt(0);
        else {
          do {
            _snakeFoodPosition = _random.nextInt(_noOfSquares);
          } while (_snake.contains(_snakeFoodPosition));
        }

        if (_gameOver()) {
          setState(() {
            _hasStarted = !_hasStarted;
          });
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => GameOver(score: _playerScore,customerId: widget.customerId,)));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Snake', style: TextStyle(color: Colors.white, fontSize: 20.0)),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
        actions: <Widget>[
          Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text('Score: $_playerScore', style: TextStyle(fontSize: 16.0)),
              )
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.redAccent,
        elevation: 20,
        label: Text(
          _hasStarted ? 'Start' : 'Pause',
          style: TextStyle(),
        ),
        onPressed: () {
          setState(() {
            if (_hasStarted) {
              _snakeAnimationController.forward();
            } else {
              _snakeAnimationController.reverse();
            }
            _hasStarted = !_hasStarted;
            _gameStart();
          });
        },
        icon: AnimatedIcon(icon: AnimatedIcons.play_pause, progress: _snakeAnimationController),
      ),
      body: Center(
        child: GestureDetector(
          onVerticalDragUpdate: (drag) {
            if (drag.delta.dy > 0 && _currentSnakeDirection != 'UP') _currentSnakeDirection = 'DOWN';
            else if (drag.delta.dy < 0 && _currentSnakeDirection != 'DOWN') _currentSnakeDirection = 'UP';
          },
          onHorizontalDragUpdate: (drag) {
            if (drag.delta.dx > 0 && _currentSnakeDirection != 'LEFT') _currentSnakeDirection = 'RIGHT';
            else if (drag.delta.dx < 0 && _currentSnakeDirection != 'RIGHT') _currentSnakeDirection = 'LEFT';
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: GridView.builder(
              itemCount: _squareSize + _noOfSquares,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: _squareSize),
              itemBuilder: (BuildContext context, int index) {
                return Center(
                  child: Container(
                    color: Colors.white,
                    padding: _snake.contains(index) ? EdgeInsets.all(1) : EdgeInsets.all(0),
                    child: ClipRRect(
                      borderRadius: index == _snakeFoodPosition || index == _snake.last ? BorderRadius.circular(7) : _snake.contains(index) ? BorderRadius.circular(2.5) : BorderRadius.circular(1),
                      child: Container(
                        color: _snake.contains(index) ? Colors.black : index == _snakeFoodPosition ? Colors.green : Colors.blue
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
