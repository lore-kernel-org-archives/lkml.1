Return-Path: <linux-kernel-owner+w=401wt.eu-S1757943AbYFVTJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757943AbYFVTJ0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 15:09:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756384AbYFVTFQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 15:05:16 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36271 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756261AbYFVTFI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 15:05:08 -0400
Cc: "Alexey Dobriyan" <adobriyan@gmail.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Oleg Nesterov" <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
References: <RzbtSgMztjP.A.jRD._spXIB@albercik>
In-Reply-To: <RzbtSgMztjP.A.jRD._spXIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <4mRZUF-hVeG.A.GxF.5upXIB@albercik>
Subject: [Bug #10815] 2.6.26-rc4: RIP find_pid_ns+0x6b/0xa0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 22 Jun 2008 19:54:46 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.25.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10815
Subject		: 2.6.26-rc4: RIP find_pid_ns+0x6b/0xa0
Submitter	: Alexey Dobriyan <adobriyan@gmail.com>
Date		: 2008-05-27 09:23 (27 days old)
References	: http://lkml.org/lkml/2008/5/27/9
		  http://lkml.org/lkml/2008/6/14/87
Handled-By	: Oleg Nesterov <oleg@tv-sign.ru>
		  Linus Torvalds <torvalds@linux-foundation.org>
		  Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Patch		: http://lkml.org/lkml/2008/5/28/16


