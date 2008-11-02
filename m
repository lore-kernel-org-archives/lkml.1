Return-Path: <linux-kernel-owner+w=401wt.eu-S1755375AbYKBSry@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375AbYKBSry (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 13:47:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754859AbYKBSoQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 13:44:16 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:36141 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754294AbYKBSoH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 13:44:07 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Pavel Machek" <pavel@suse.cz>, "Pekka Enberg" <penberg@cs.helsinki.fi>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Vegard Nossum" <vegard.nossum@gmail.com>
References: <Sl8SUNhCbfL.A.O5H.yueDJB@chimera>
In-Reply-To: <Sl8SUNhCbfL.A.O5H.yueDJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <4xS1r6m15_B.A.KUC.GxeDJB@chimera>
Subject: [Bug #11407] suspend: unable to handle kernel paging request
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  2 Nov 2008 17:49:33 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.26 and 2.6.27.

The following bug entry is on the current list of known regressions
introduced between 2.6.26 and 2.6.27.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11407
Subject		: suspend: unable to handle kernel paging request
Submitter	: Vegard Nossum <vegard.nossum@gmail.com>
Date		: 2008-08-21 17:28 (74 days old)
References	: http://marc.info/?l=linux-kernel&m=121933974928881&w=4
Handled-By	: Rafael J. Wysocki <rjw@sisk.pl>
		  Pekka Enberg <penberg@cs.helsinki.fi>
		  Pavel Machek <pavel@suse.cz>


