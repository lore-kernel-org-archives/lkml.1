Return-Path: <linux-kernel-owner+w=401wt.eu-S934502AbZLPCIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934502AbZLPCIV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 21:08:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934470AbZLPCIU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 21:08:20 -0500
Received: from hera.kernel.org ([140.211.167.34]:49806 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934382AbZLPCIT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 21:08:19 -0500
Message-ID: <4B2840BF.7010100@kernel.org>
Date: Tue, 15 Dec 2009 18:06:55 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: x86 related patches 12-15-2009
References: <4B07A658.8080709@kernel.org> <4B07A739.3030104@kernel.org>
In-Reply-To: <4B07A739.3030104@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


please check several patches from
git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-2.6-yinghai.git for-tip

http://git.kernel.org/?p=linux/kernel/git/yinghai/linux-2.6-yinghai.git;a=shortlog;h=refs/heads/for-tip

1a88d3a: x86: check range in update range
0fb059e: x86: move range related operation to one file
8a81618: x86: only call dma32_reserve_bootmem 64bit !CONFIG_NUMA
75d6a28: x86: make early_node_mem get mem > 4g if possible -v2
557bcb7: x86: print bootmem free before pci_iommu_alloc and free_all_bootmem
72fe68a: x86: dynamic increase early_res array size
de4546b: x86: introduce max_early_res and early_res_count
1caafab: x86: call early_res_to_bootmem one time
daefc77: x86: increase MAX_EARLY_RES
a9dc1ac: x86: fix checking of SRAT when node0 ram is not from 0 -v3


Thanks

Yinghai

