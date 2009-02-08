Return-Path: <linux-kernel-owner+w=401wt.eu-S1754330AbZBHVsc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754330AbZBHVsc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 16:48:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753558AbZBHVrv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 16:47:51 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39589 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753390AbZBHVru convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 16:47:50 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Graham Murray" <graham@gmurray.org.uk>
References: <AIghyjFgMFP.A.uZD._10jJB@chimera>
In-Reply-To: <AIghyjFgMFP.A.uZD._10jJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <sWhNs83kKPE.A.gtH.930jJB@chimera>
Subject: [Bug #12444] X hangs following switch from radeonfb console - Bisected
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  8 Feb 2009 20:21:38 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.28.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12444
Subject		: X hangs following switch from radeonfb console - Bisected
Submitter	: Graham Murray <graham@gmurray.org.uk>
Date		: 2009-01-13 14:03 (27 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=7c1c2871a6a3a114853ec6836e9035ac1c0c7f7a


