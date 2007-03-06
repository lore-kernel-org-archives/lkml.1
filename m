Return-Path: <linux-kernel-owner+w=401wt.eu-S965848AbXCFLLD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965848AbXCFLLD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 06:11:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965849AbXCFLLD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 06:11:03 -0500
Received: from mail.gmx.net ([213.165.64.20]:37404 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S965848AbXCFLLB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 06:11:01 -0500
X-Provags-ID: V01U2FsdGVkX1+D2IkhPkeDGOJZV7x8FQjJFbazbEOA7I9gnsUi5P
	CEp48EgW1AQHAO
Subject: 2.6.21-rc2-mm2 rtc_cmos cart/horse problem
From: Mike Galbraith <efault@gmx.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: rtc-linux@googlegroups.com
Content-Type: text/plain
Date: Tue, 06 Mar 2007 12:10:59 +0100
Message-Id: <1173179459.6813.10.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

I noticed the below during boot.

[   28.772015] drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
[   35.451802] rtc_cmos: dev (239:0)
[   35.461708] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[   35.474330] rtc0: alarms up to one month

	-Mike

