Return-Path: <linux-kernel-owner+w=401wt.eu-S1752652AbZLZL3B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652AbZLZL3B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Dec 2009 06:29:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751951AbZLZL3A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Dec 2009 06:29:00 -0500
Received: from qmta04.emeryville.ca.mail.comcast.net ([76.96.30.40]:44558 "EHLO
	QMTA04.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751921AbZLZL3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Dec 2009 06:29:00 -0500
Subject: Array Subscript Warning - eicon/message.c - 2.6.33-rc2
From: Chris Holvenstot <cholvenstot@comcast.net>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 26 Dec 2009 05:28:57 -0600
Message-ID: <1261826937.16211.9.camel@popeye.holvenstot.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am not sure if this warrants reporting or if anyone is interested, but
while building 2.6.33-rc2 I saw the following warnings scroll across my
screen.  Not being an ISDN user I can not provide any information as to
the functionality of the effected module but array bounding errors tend
to make my backside pucker.  

The build was performed on a "tweaked" debian / squeeze system with GCC
4.3.4

Thank you

drivers/isdn/hardware/eicon/message.c:8426: warning: array subscript is
above array bounds
drivers/isdn/hardware/eicon/message.c:8427: warning: array subscript is
above array bounds
drivers/isdn/hardware/eicon/message.c:8434: warning: array subscript is
above array bounds
drivers/isdn/hardware/eicon/message.c:8435: warning: array subscript is
above array bounds
drivers/isdn/hardware/eicon/message.c:8436: warning: array subscript is
above array bounds
drivers/isdn/hardware/eicon/message.c:8447: warning: array subscript is
above array bounds




