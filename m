Return-Path: <linux-kernel-owner+w=401wt.eu-S1752709Ab0ABObT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709Ab0ABObT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 09:31:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752570Ab0ABObT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 09:31:19 -0500
Received: from mailout1.go2.pl ([193.17.41.11]:38110 "EHLO mailout1.go2.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752121Ab0ABObS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 09:31:18 -0500
Subject: =?UTF-8?Q?[suspend/resume]_Re:_userspace_notification_from_module_?=
From: =?UTF-8?Q?Bart=C5=82omiej_Zimo=C5=84?= <uzi18@o2.pl>
To: linux-kernel@vger.kernel.org
In-Reply-To: <4B3F5264.7000008@gmail.com>
References: <686edb2c.6263643a.4b3f4a3b.b60b3@o2.pl> <4B3F5264.7000008@gmail.com>
Mime-Version: 1.0
Message-ID: <7d0b7c65.41700a71.4b3f58b4.b227b@o2.pl>
Date: Sat, 02 Jan 2010 15:31:16 +0100
X-Originator: 83.12.131.34
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dnia 2 stycznia 2010 15:04 	Daniel Borkmann <danborkmann@googlemail.com> napisał(a):
> 
> I guess netlink could be the "cleaner" solution, but with more overhead?!
> 

Could be, but remember we have small amount of time from pm notify to freeze processes.

Best Regards
Bartłomiej Zimoń
PLD Linux, Kadu Team
