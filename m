Return-Path: <linux-kernel-owner+w=401wt.eu-S1761664AbZATAFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761664AbZATAFz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 19:05:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761183AbZASXx6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 18:53:58 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40403 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761149AbZASXxy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 18:53:54 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Andrea Righi" <righi.andrea@gmail.com>,
       "Dave Jones" <davej@redhat.com>,
       "Harvey Harrison" <harvey.harrison@gmail.com>,
       "Johannes Weiner" <hannes@cmpxchg.org>,
       "Stefan Richter" <stefanr@s5r6.in-berlin.de>
References: <0GOi9pntEoL.A.iGF.B9QdJB@chimera>
In-Reply-To: <0GOi9pntEoL.A.iGF.B9QdJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <2QN7KFic7LG.A.jcF.I9QdJB@chimera>
Subject: [Bug #12509] lockdep report. fb_mmap vs sys_mmap2
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 19 Jan 2009 22:32:20 +0100 (CET)
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
Date		: 2009-01-17 18:19 (3 days old)
References	: http://lkml.org/lkml/2009/1/17/176
Handled-By	: Andrea Righi <righi.andrea@gmail.com>
Patch		: http://marc.info/?l=linux-kernel&m=123231032115956&w=4


