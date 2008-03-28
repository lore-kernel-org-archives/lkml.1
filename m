Return-Path: <linux-kernel-owner+w=401wt.eu-S1757834AbYC1Cac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757834AbYC1Cac (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 22:30:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757373AbYC1CaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 22:30:20 -0400
Received: from relay1.sgi.com ([192.48.171.29]:39153 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754737AbYC1CaT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 22:30:19 -0400
Message-Id: <20080328023018.264203000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 27 Mar 2008 19:30:18 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] generic: simplify setup_nr_cpu_ids and add set_cpus_allowed_ptr
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Two simple patches to simplify setup_nr_cpu_ids and add a new function,
set_cpus_allowed_ptr().

Based on:
	git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
	git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git


Signed-off-by: Mike Travis <travis@sgi.com>
---
v2: fixed the EXPORT_SYMBOL for set_cpus_allowed_ptr()

-- 
