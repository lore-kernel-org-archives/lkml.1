Return-Path: <linux-kernel-owner+w=401wt.eu-S1163436AbXD1SOm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163436AbXD1SOm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 14:14:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1163295AbXD1Rwi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 13:52:38 -0400
Received: from ns2.suse.de ([195.135.220.15]:38585 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163279AbXD1Rwd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 13:52:33 -0400
From: Andi Kleen <ak@suse.de>
Message-Id: <20070428752.712152000@suse.de>
To: linux-kernel@vger.kernel.org, patches@x86-64.org
Subject: [PATCH] [0/35] Some x86 2.6.22 candidate patches for review
Date: Sat, 28 Apr 2007 19:52:23 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Here are some 2.6.22 candidate x86 patches for review. I will be posting more 
over a few days.

This first batch has:
- Ingo's genapic rework. Now we always use physical mode on x86-64.
- Lots of minor stuff

Please review.

-Andi

