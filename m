Return-Path: <linux-kernel-owner+w=401wt.eu-S1762014AbZASX5l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762014AbZASX5l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 18:57:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760259AbZASXwi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 18:52:38 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40319 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760727AbZASXwf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 18:52:35 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alex Riesen" <fork0@users.sf.net>, "Ingo Molnar" <mingo@elte.hu>
References: <0GOi9pntEoL.A.iGF.B9QdJB@chimera>
In-Reply-To: <0GOi9pntEoL.A.iGF.B9QdJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <2QN7KFic7LG.A.sgH.t9QdJB@chimera>
Subject: [Bug #12468] Crash in acpi_cpufreq_init
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 19 Jan 2009 22:32:14 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.28.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12468
Subject		: Crash in acpi_cpufreq_init
Submitter	: Alex Riesen <fork0@users.sf.net>
Date		: 2009-01-17 10:47 (3 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=50c668d678fd01284799a6e4f1b91829d83cb9ed


