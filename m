Return-Path: <linux-kernel-owner+w=401wt.eu-S1754416AbYKBSv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754416AbYKBSv0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 13:51:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755020AbYKBSou
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 13:44:50 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:36185 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754944AbYKBSoo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 13:44:44 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Dave Chinner" <dgc@sgi.com>,
       "Tiago Maluta" <maluta_tiago@yahoo.com.br>
References: <Sl8SUNhCbfL.A.O5H.yueDJB@chimera>
In-Reply-To: <Sl8SUNhCbfL.A.O5H.yueDJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <4xS1r6m15_B.A.m8.KveDJB@chimera>
Subject: [Bug #11805] mounting XFS produces a segfault
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  2 Nov 2008 17:49:36 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.26 and 2.6.27.

The following bug entry is on the current list of known regressions
introduced between 2.6.26 and 2.6.27.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11805
Subject		: mounting XFS produces a segfault
Submitter	: Tiago Maluta <maluta_tiago@yahoo.com.br>
Date		: 2008-10-21 18:00 (13 days old)
Handled-By	: Dave Chinner <dgc@sgi.com>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=18397&action=view


