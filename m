Return-Path: <linux-kernel-owner+w=401wt.eu-S1757510AbXLRXi2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757510AbXLRXi2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 18:38:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753601AbXLRXiA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 18:38:00 -0500
Received: from relay1.sgi.com ([192.48.171.29]:41566 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751535AbXLRXh6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 18:37:58 -0500
Message-Id: <20071218233757.981161000@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 18 Dec 2007 15:37:57 -0800
From: travis@sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <ak@suse.de>, Christoph Lameter <clameter@sgi.com>,
       Jack Steiner <steiner@sgi.com>,
       Suresh B Siddha <suresh.b.siddha@intel.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/1] x86: fix show cpuinfo cpu number always zero
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It appears that this patch is missing from the latest 2.6.24 git
kernel as well as the 2.6.24-rc5-mm1 patch?

> Mike, This issue still seems to be present in linus git tree. Perhaps
> the fix in -mm not pushed to mainline yet.
> 
> Can you please raise the flag with Andrew, so that he can push it before
> 2.6.24 gets out
> 

-- 
