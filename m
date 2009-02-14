Return-Path: <linux-kernel-owner+w=401wt.eu-S1754252AbZBNXH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754252AbZBNXH3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 18:07:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753396AbZBNXGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 18:06:10 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44524 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752883AbZBNXGG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 18:06:06 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Graham Murray" <graham@gmurray.org.uk>
References: <juADNmcceYF.A.mdD.Mr0lJB@chimera>
In-Reply-To: <juADNmcceYF.A.mdD.Mr0lJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <rjPbZ5GRJPO.A._pG.Lt0lJB@chimera>
Subject: [Bug #12444] X hangs following switch from radeonfb console - Bisected
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 14 Feb 2009 21:38:15 +0100 (CET)
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
Date		: 2009-01-13 14:03 (33 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=7c1c2871a6a3a114853ec6836e9035ac1c0c7f7a


