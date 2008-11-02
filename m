Return-Path: <linux-kernel-owner+w=401wt.eu-S1754713AbYKBSnv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713AbYKBSnv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 13:43:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754015AbYKBSn1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 13:43:27 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:36105 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753238AbYKBSn0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 13:43:26 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
References: <Sl8SUNhCbfL.A.O5H.yueDJB@chimera>
In-Reply-To: <Sl8SUNhCbfL.A.O5H.yueDJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <4xS1r6m15_B.A.FQD.bzeDJB@chimera>
Subject: [Bug #11215] INFO: possible recursive locking detected ps2_command
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  2 Nov 2008 17:49:31 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.26 and 2.6.27.

The following bug entry is on the current list of known regressions
introduced between 2.6.26 and 2.6.27.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11215
Subject		: INFO: possible recursive locking detected ps2_command
Submitter	: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Date		: 2008-07-31 9:41 (95 days old)
References	: http://marc.info/?l=linux-kernel&m=121749737011637&w=4
Handled-By	: Peter Zijlstra <a.p.zijlstra@chello.nl>


