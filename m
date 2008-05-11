Return-Path: <linux-kernel-owner+w=401wt.eu-S1760825AbYEKVHp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760825AbYEKVHp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 17:07:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759286AbYEKVBk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 17:01:40 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34113 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759046AbYEKVB0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 17:01:26 -0400
Cc: "Ingo Molnar" <mingo@elte.hu>, "Jan Beulich" <jbeulich@novell.com>,
       =?utf-8?q?Simon=20Holm=20Th=C3=B8gersen?= <odie@cs.aau.dk>,
       "Thomas Gleixner" <tglx@linutronix.de>
References: <hPXlJLjt4XG.A._lF.Jv1JIB@chimera>
In-Reply-To: <hPXlJLjt4XG.A._lF.Jv1JIB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <88YBFoyd1CN.A.8_H.Xw1JIB@chimera>
Subject: [Bug #10631] Please revert 709f744 (x86: bitops asm constraint fixes)
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 11 May 2008 22:04:14 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.25.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10631
Subject		: Please revert 709f744 (x86: bitops asm constraint fixes)
Submitter	: Simon Holm Thøgersen <odie@cs.aau.dk>
Date		: 2005-05-05 09:35 (1103 days old)
References	: http://www.ussg.iu.edu/hypermail/linux/kernel/0805.0/1963.html
Handled-By	: Ingo Molnar <mingo@elte.hu>
		  Jan Beulich <jbeulich@novell.com>
		  Thomas Gleixner <tglx@linutronix.de>
Patch		: http://www.ussg.iu.edu/hypermail/linux/kernel/0805.0/2661.html


