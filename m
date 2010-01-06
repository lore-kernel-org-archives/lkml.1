Return-Path: <linux-kernel-owner+w=401wt.eu-S1755211Ab0AFBFp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755211Ab0AFBFp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 20:05:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755180Ab0AFBFm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 20:05:42 -0500
Received: from mailout1.go2.pl ([193.17.41.11]:46400 "EHLO mailout1.go2.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754650Ab0AFBFl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 20:05:41 -0500
Subject: =?UTF-8?Q?Re:_[linux-pm]_[suspend/resume]_Re:_userspace_notification=09?=
	=?UTF-8?Q?_from_module?=
From: =?UTF-8?Q?Bart=C5=82omiej_Zimo=C5=84?= <uzi18@o2.pl>
To: linux-kernel@vger.kernel.org
Cc: rjw@sisk.pl, aeriksson@fastmail.fm, stefan.seyfried@googlemail.com,
       linux-pm@lists.linux-foundation.org, danborkmann@googlemail.com,
       awalls@radix.net
Mime-Version: 1.0
Message-ID: <1df13dac.5ba05e5c.4b43e1e2.120e@o2.pl>
Date: Wed, 06 Jan 2010 02:05:38 +0100
X-Originator: 83.12.131.34
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dnia 6 stycznia 2010 0:05 	"Rafael J. Wysocki" <rjw@sisk.pl> napisał(a):
> Well, I think you have some specific issue with pm-utils, but you're not
> telling us what it is.  So, why exactly is pm-utils not suitable for your
> needs?
> 

Rafael to be honest it's more dbus specific. I'm talking about 
dbus as it is standard for system<->apps communication.

But please understand if we'll create kernel device with simple pm notification
It could be hooked by udev and next ... by DeviceKit-power/upower and after that
we have real standard. But to have this we must export "power" device - something 
like my proof-of-concept module. This could be realy good start.

Best regards.
Bartłomiej Zimoń
PLD Linux, Kadu Team, FreeRunner user
http://kadu-im.blogspot.com/


