Return-Path: <linux-kernel-owner+w=401wt.eu-S1758069AbZBDM4f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758069AbZBDM4f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 07:56:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756569AbZBDMt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 07:49:59 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45001 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756559AbZBDMt5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 07:49:57 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Andrea Righi" <righi.andrea@gmail.com>,
       "Dave Jones" <davej@redhat.com>,
       "Harvey Harrison" <harvey.harrison@gmail.com>,
       "Johannes Weiner" <hannes@cmpxchg.org>,
       "Stefan Richter" <stefanr@s5r6.in-berlin.de>
References: <kkuKoQJIW-D.A.61C.auYiJB@chimera>
In-Reply-To: <kkuKoQJIW-D.A.61C.auYiJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <pWZw1SZjMCH.A.Z_F.WvYiJB@chimera>
Subject: [Bug #12509] lockdep report. fb_mmap vs sys_mmap2
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed,  4 Feb 2009 11:24:01 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.28.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12509
Subject		: lockdep report. fb_mmap vs sys_mmap2
Submitter	: Dave Jones <davej@redhat.com>
Date		: 2009-01-17 18:19 (19 days old)
References	: http://lkml.org/lkml/2009/1/17/176
Handled-By	: Andrea Righi <righi.andrea@gmail.com>
Patch		: http://marc.info/?l=linux-kernel&m=123231032115956&w=4


