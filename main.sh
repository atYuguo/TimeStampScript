#!/bin/bash
#-------------CopyRight-------------
#    名称:文件可信时间戳工具入口
#    语言:bash shell
#    时间:2013-03-31
#    作者:Hugo Qin
#    邮箱:fireuponsky@gmail.com
#-------------许可证-------------
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#------------------------------

#除了执行命令还写log文件
MAINSHDATE=$(date)
echo "--------$MAINSHDATE---BEGIN--------" >> log
sh ./timesign.sh 2>&1 | tee -a log
echo "--------$MAINSHDATE---end--------" >> log
echo -e "\n" >> log
