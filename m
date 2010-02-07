Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616Ab0BGWqv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 17:46:51 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:55208 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757683Ab0BGWqq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 17:46:46 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Arnd Bergmann" <arnd@arndb.de>,
       "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>
References: <4Ht3jFrT7uE.A.JI.-nzbLB@chimera>
In-Reply-To: <4Ht3jFrT7uE.A.JI.-nzbLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <445R0ey9hAI.A.nQ.DozbLB@chimera>
Subject: [Bug #15251] ioctl32(mdadm:2243): Unknown cmd fd(3) cmd(800c0910){t:09;sz:12} arg(ffb7f9c4)
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  7 Feb 2010 23:28:55 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.32.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15251
Subject		: ioctl32(mdadm:2243): Unknown cmd fd(3) cmd(800c0910){t:09;sz:12} arg(ffb7f9c4)
Submitter	: Michael S. Tsirkin <m.s.tsirkin@gmail.com>
Date		: 2010-01-30 22:02 (9 days old)
Message-ID	: <201001302302.10574.arnd@arndb.de>
References	: http://marc.info/?l=linux-kernel&m=126489038709553&w=4
Handled-By	: Arnd Bergmann <arnd@arndb.de>
Patch		: http://patchwork.kernel.org/patch/75931/


