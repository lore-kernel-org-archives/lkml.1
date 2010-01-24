Return-Path: <linux-kernel-owner+w=401wt.eu-S1754838Ab0AXWhw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838Ab0AXWhw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 17:37:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754816Ab0AXWhn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 17:37:43 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45888 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753187Ab0AXWhc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 17:37:32 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "David John" <davidjon@xenontk.org>,
       "Luiz Augusto von Dentz" <luiz.dentz@openbossa.org>,
       "Marcel Holtmann" <marcel@holtmann.org>
References: <pYFNu11z2aM.A.pJH.CZMXLB@chimera>
In-Reply-To: <pYFNu11z2aM.A.pJH.CZMXLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <q60Z28d_9yH.A.neH.KZMXLB@chimera>
Subject: [Bug #15127] Bluetooth: sleeping function called from invalid context
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 24 Jan 2010 23:23:14 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.31 and 2.6.32.

The following bug entry is on the current list of known regressions
introduced between 2.6.31 and 2.6.32.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15127
Subject		: Bluetooth: sleeping function called from invalid context
Submitter	: David John <davidjon@xenontk.org>
Date		: 2010-01-12 9:19 (13 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=9e726b17422bade75fba94e625cd35fd1353e682
References	: http://marc.info/?l=linux-kernel&m=126328727021949&w=4


