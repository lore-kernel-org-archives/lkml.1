Return-Path: <linux-kernel-owner+w=401wt.eu-S964969AbXBOHbJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964969AbXBOHbJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 02:31:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964971AbXBOHbJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 02:31:09 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45300 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964970AbXBOHbG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 02:31:06 -0500
From: Nick Piggin <npiggin@suse.de>
To: Andrew Morton <akpm@osdl.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@suse.de>,
       Linux Memory Management <linux-mm@kvack.org>
Message-Id: <20070215051822.7443.30110.sendpatchset@linux.site>
Subject: [patch 0/3] 2.6.20 fix for PageUptodate memorder problem (try 4)
Date: Thu, 15 Feb 2007 08:31:02 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Various little cleanups and commenting fixes. Fixed up the patchset so
each one, incrementally, should give a properly compiling and running
kernel.

I'd still like Hugh to ack the anon/swap changes when he can find the time.
It would be desirable to get at least one ack as to the overall problem and
design of the fix (Martin's ack is just for the s390 changes at this stage).

Meanwhile, can it go into -mm for wider testing, if it isn't too much
trouble?

Thanks,
Nick

--
SuSE Labs

