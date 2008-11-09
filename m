Return-Path: <linux-kernel-owner+w=401wt.eu-S1757549AbYKIVlp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757549AbYKIVlp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 16:41:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757351AbYKIVkA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 16:40:00 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45079 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756806AbYKIVj7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 16:39:59 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "John Daiker" <daikerjohn@gmail.com>
References: <A3oCZU7cpuO.A.ChB.ZZ1FJB@chimera>
In-Reply-To: <A3oCZU7cpuO.A.ChB.ZZ1FJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <4B0Eqx89uNG.A.62C.Za1FJB@chimera>
Subject: [Bug #11608] 2.6.27-rc6 BUG: unable to handle kernel paging request
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  9 Nov 2008 20:43:20 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.26 and 2.6.27.

The following bug entry is on the current list of known regressions
introduced between 2.6.26 and 2.6.27.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11608
Subject		: 2.6.27-rc6 BUG: unable to handle kernel paging request
Submitter	: John Daiker <daikerjohn@gmail.com>
Date		: 2008-09-16 23:00 (55 days old)
References	: http://marc.info/?l=linux-kernel&m=122160611517267&w=4


