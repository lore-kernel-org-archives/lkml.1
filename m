Return-Path: <linux-kernel-owner+w=401wt.eu-S1760771AbYILU5i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760771AbYILU5i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 16:57:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758615AbYILUqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 16:46:13 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42896 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758555AbYILUqJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 16:46:09 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Randy.Dunlap" <rdunlap@xenotime.net>,
       =?utf-8?q?Toralf=20F=C3=B6rster?= <toralf.foerster@gmx.de>
References: <j3zWxt-CgYL.A.WTF.bbsyIB@albercik>
In-Reply-To: <j3zWxt-CgYL.A.WTF.bbsyIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <SpS7rta8n4.A.MXG.-bsyIB@albercik>
Subject: [Bug #11547] build issue #565 for v2.6.27-rc5 : undefined reference to `ei_interrupt' in hp-plus.c
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Fri, 12 Sep 2008 21:06:30 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.26.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11547
Subject		: build issue #565 for v2.6.27-rc5 : undefined reference to `ei_interrupt' in hp-plus.c
Submitter	: Toralf Förster <toralf.foerster@gmx.de>
Date		: 2008-09-07 13:19 (6 days old)
References	: http://marc.info/?l=linux-kernel&m=122079361508022&w=4
Handled-By	: Randy.Dunlap <rdunlap@xenotime.net>
Patch		: http://marc.info/?l=linux-next&m=122038632306156&w=2


