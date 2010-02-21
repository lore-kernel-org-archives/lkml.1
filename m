Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754926Ab0BUWF5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 17:05:57 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:59044 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754855Ab0BUWFx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 17:05:53 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Len Brown" <len.brown@intel.com>,
       "=?utf-8?q?Rafa=C5=82=20Mi=C5=82ecki?=" <zajec5@gmail.com>,
       "Stefan Bader" <stefan.bader@canonical.com>,
       "Zhang Rui" <rui.zhang@intel.com>
References: <4u4d-2M3yXH.A.XW.XqagLB@chimera>
In-Reply-To: <4u4d-2M3yXH.A.XW.XqagLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <wj3ZQZlk_KB.A.OgB.cragLB@chimera>
Subject: [Bug #15096] Resume lock up -- bisected, commit 3a1151e3f124fd1a2c54b8153f510f1a7c715369
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 21 Feb 2010 22:42:41 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.31 and 2.6.32.

The following bug entry is on the current list of known regressions
introduced between 2.6.31 and 2.6.32.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15096
Subject		: Resume lock up -- bisected, commit 3a1151e3f124fd1a2c54b8153f510f1a7c715369
Submitter	: Rafał Miłecki <zajec5@gmail.com>
Date		: 2010-01-20 23:15 (33 days old)
First-Bad-Commit: http://git.kernel.org/git/linus/3a1151e3f124fd1a2c54b8153f510f1a7c715369


