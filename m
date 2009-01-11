Return-Path: <linux-kernel-owner+w=401wt.eu-S1756795AbZAKOIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756795AbZAKOIu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 09:08:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755229AbZAKN7a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 08:59:30 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:36909 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754901AbZAKN73 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 08:59:29 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alan Stern" <stern@rowland.harvard.edu>,
       "Greg Kroah-Hartman" <gregkh@suse.de>,
       "Jan Scholz" <scholz@fias.uni-frankfurt.de>
References: <nn3SOLVZ28H.A.bY.CafaJB@chimera>
In-Reply-To: <nn3SOLVZ28H.A.bY.CafaJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <nHCfeC0YLrE.A.Bw.NafaJB@chimera>
Subject: [Bug #12412] Regression in v2.6.28 introduced by: 'USB: skip Set-Interface(0) if already in altsetting 0'
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 11 Jan 2009 12:41:09 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.27 and 2.6.28.

The following bug entry is on the current list of known regressions
introduced between 2.6.27 and 2.6.28.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12412
Subject		: Regression in v2.6.28 introduced by: 'USB: skip Set-Interface(0) if already in altsetting 0'
Submitter	: Jan Scholz <scholz@fias.uni-frankfurt.de>
Date		: 2009-01-02 11:04 (10 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=24c0996a6b73e2554104961afcc8659534503e0d
References	: http://marc.info/?l=linux-kernel&m=123089613601599&w=4


