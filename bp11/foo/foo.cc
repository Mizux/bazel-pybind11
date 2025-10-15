#include "bp11/foo/foo.h"

#include <iostream>
#include <string>
#include <utility>

namespace bp11::foo {
void freeFunction(int level) {
  std::cout << "[" << level << "] Enter " << __func__ << "(int)" << std::endl;
  std::cout << "[" << level << "] Exit " << __func__ << "(int)" << std::endl;
}

void freeFunction(int64_t level) {
  std::cout << "[" << level << "] Enter " << __func__ << "(int64_t)"
            << std::endl;
  std::cout << "[" << level << "] Exit " << __func__ << "(int64_t)"
            << std::endl;
}

std::vector<std::string> stringVectorOutput(int level) {
  std::cout << "[" << level << "] Enter " << __func__ << "()" << std::endl;
  std::vector<std::string> result(level, std::to_string(level));
  std::cout << "[" << level << "] Exit " << __func__ << "()" << std::endl;
  return result;
}

int stringVectorInput(std::vector<std::string> data) {
  std::cout << "Enter " << __func__ << "()" << std::endl;
  std::cout << "{";
  for (const auto& item : data) {
    std::cout << item << ", ";
  }
  std::cout << "}" << std::endl;
  std::cout << "Exit " << __func__ << "()" << std::endl;
  return data.size();
}

int stringVectorRefInput(const std::vector<std::string>& data) {
  std::cout << "Enter " << __func__ << "()" << std::endl;
  std::cout << "{";
  for (const auto& item : data) {
    std::cout << item << ", ";
  }
  std::cout << "}" << std::endl;
  std::cout << "Exit " << __func__ << "()" << std::endl;
  return data.size();
}

std::vector<std::vector<std::string>> stringJaggedArrayOutput(int level) {
  std::cout << "[" << level << "] Enter " << __func__ << "()" << std::endl;
  std::vector<std::vector<std::string>> result;
  result.reserve(level);
  for (int i = 1; i <= level; ++i) {
    result.emplace_back(std::vector<std::string>(i, std::to_string(i)));
  }
  std::cout << "[" << level << "] Exit " << __func__ << "()" << std::endl;
  return result;
}

int stringJaggedArrayInput(std::vector<std::vector<std::string>> data) {
  std::cout << "Enter " << __func__ << "()" << std::endl;
  std::cout << "{";
  for (const auto& inner : data) {
    std::cout << "{";
    for (const auto& item : inner) {
      std::cout << item << ", ";
    }
    std::cout << "}, ";
  }
  std::cout << "}" << std::endl;
  std::cout << "Exit " << __func__ << "()" << std::endl;
  return data.size();
}

int stringJaggedArrayRefInput(
    const std::vector<std::vector<std::string>>& data) {
  std::cout << "Enter " << __func__ << "()" << std::endl;
  std::cout << "{";
  for (const auto& inner : data) {
    std::cout << "{";
    for (const auto& item : inner) {
      std::cout << item << ", ";
    }
    std::cout << "}, ";
  }
  std::cout << "}" << std::endl;
  std::cout << "Exit " << __func__ << "()" << std::endl;
  return data.size();
}

std::vector<std::pair<int, int>> pairVectorOutput(int level) {
  std::cout << "[" << level << "] Enter " << __func__ << "()" << std::endl;
  std::vector<std::pair<int, int>> result(level, std::make_pair(level, level));
  std::cout << "[" << level << "] Exit " << __func__ << "()" << std::endl;
  return result;
}

int pairVectorInput(std::vector<std::pair<int, int>> data) {
  std::cout << "Enter " << __func__ << "()" << std::endl;
  std::cout << "{";
  for (const auto& item : data) {
    std::cout << "[" << item.first << "," << item.second << "], ";
  }
  std::cout << "}" << std::endl;
  std::cout << "Exit " << __func__ << "()" << std::endl;
  return data.size();
}

int pairVectorRefInput(const std::vector<std::pair<int, int>>& data) {
  std::cout << "Enter " << __func__ << "()" << std::endl;
  std::cout << "{";
  for (const auto& item : data) {
    std::cout << "[" << item.first << "," << item.second << "], ";
  }
  std::cout << "}" << std::endl;
  std::cout << "Exit " << __func__ << "()" << std::endl;
  return data.size();
}

std::vector<std::vector<std::pair<int, int>>> pairJaggedArrayOutput(int level) {
  std::cout << "[" << level << "] Enter " << __func__ << "()" << std::endl;
  std::vector<std::vector<std::pair<int, int>>> result;
  result.reserve(level);
  for (int i = 1; i <= level; ++i) {
    result.emplace_back(
        std::vector<std::pair<int, int>>(i, std::make_pair(i, i)));
  }
  std::cout << "[" << level << "] Exit " << __func__ << "()" << std::endl;
  return result;
}

int pairJaggedArrayInput(std::vector<std::vector<std::pair<int, int>>> data) {
  std::cout << "Enter " << __func__ << "()" << std::endl;
  std::cout << "{";
  for (const auto& inner : data) {
    std::cout << "{";
    for (const auto& item : inner) {
      std::cout << "[" << item.first << "," << item.second << "], ";
    }
    std::cout << "}, ";
  }
  std::cout << "}" << std::endl;
  std::cout << "Exit " << __func__ << "()" << std::endl;
  return data.size();
}

int pairJaggedArrayRefInput(
    const std::vector<std::vector<std::pair<int, int>>>& data) {
  std::cout << "Enter " << __func__ << "()" << std::endl;
  std::cout << "{";
  for (const auto& inner : data) {
    std::cout << "{";
    for (const auto& item : inner) {
      std::cout << "[" << item.first << "," << item.second << "], ";
    }
    std::cout << "}, ";
  }
  std::cout << "}" << std::endl;
  std::cout << "Exit " << __func__ << "()" << std::endl;
  return data.size();
}

void Foo::staticFunction(int level) {
  std::cout << "[" << level << "] Enter " << __func__ << "(int)" << std::endl;
  freeFunction(level + 1);
  std::cout << "[" << level << "] Exit " << __func__ << "(int)" << std::endl;
}

void Foo::staticFunction(int64_t level) {
  std::cout << "[" << level << "] Enter " << __func__ << "(int64_t)"
            << std::endl;
  freeFunction(level + 1);
  std::cout << "[" << level << "] Exit " << __func__ << "(int64_t)"
            << std::endl;
}

int Foo::getInt() const { return _intValue; }

void Foo::setInt(int input) { _intValue = input; }

int64_t Foo::getInt64() const { return _int64Value; }

void Foo::setInt64(int64_t input) { _int64Value = input; }

std::string Foo::operator()() const {
  return std::string{"\"Foo\":{\"int\":"} + std::to_string(_intValue) +
         ",\"int64\":" + std::to_string(_int64Value) + "}";
}

}  // namespace bp11::foo
