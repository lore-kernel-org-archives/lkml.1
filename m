Return-Path: <linux-kernel-owner+w=401wt.eu-S1758695AbYGSBMM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758695AbYGSBMM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 21:12:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754325AbYGSBL3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 21:11:29 -0400
Received: from relay2.sgi.com ([192.48.171.30]:60205 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752946AbYGSBL2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 21:11:28 -0400
Message-Id: <20080719011126.745278000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 18 Jul 2008 18:11:26 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/8] NR_CPUS: Various replacements for NR_CPUS
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I've found one old patch that seems to have been misplaced and
a few minor new instances where usage of NR_CPUS may be incorrect.

Also a fixup for CPUMASK_ALLOC is included.

Signed-off-by: Mike Travis <travis@sgi.com>
---

-- 
