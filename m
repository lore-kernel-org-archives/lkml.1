Return-Path: <linux-kernel-owner+w=401wt.eu-S1751439AbXBFICH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751439AbXBFICH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 03:02:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751325AbXBFICH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 03:02:07 -0500
Received: from mail.suse.de ([195.135.220.2]:56558 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751391AbXBFICG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 03:02:06 -0500
From: Nick Piggin <npiggin@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Hugh Dickins <hugh@veritas.com>, Andrew Morton <akpm@osdl.org>,
       Linux Memory Management <linux-mm@kvack.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>,
       Linux Filesystems <linux-fsdevel@vger.kernel.org>
Message-Id: <20070206054925.21042.50546.sendpatchset@linux.site>
Subject: [patch 0/3] 2.6.20 fix for PageUptodate memorder problem
Date: Tue,  6 Feb 2007 09:02:01 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Still no independent confirmation as to whether this is a problem or not.
I think it is, so I'll propose this patchset to fix it. Patch 1/3 has a
reasonable description of the problem.

Thanks,
Nick

--
SuSE Labs

