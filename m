Return-Path: <linux-kernel-owner+w=401wt.eu-S1753236AbYIVQ1J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236AbYIVQ1J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 12:27:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751011AbYIVQ05
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 12:26:57 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41303 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbYIVQ04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 12:26:56 -0400
Subject: Re: [PATCH 03/23] AMD IOMMU: implement lazy IO/TLB flushing
From: David Woodhouse <dwmw2@infradead.org>
To: Joerg Roedel <joro@8bytes.org>
Cc: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       "Li, Shaohua" <shaohua.li@intel.com>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20080921090549.GK27426@8bytes.org>
References: <1221670377-19295-4-git-send-email-joerg.roedel@amd.com>
	 <20080918041104K.fujita.tomonori@lab.ntt.co.jp>
	 <20080917192827.GA18515@8bytes.org>
	 <20080918102931Z.fujita.tomonori@lab.ntt.co.jp>
	 <20080918140350.GE24392@amd.com> <20080919174339.GA29039@8bytes.org>
	 <8A3E977AB3C24845947ADAAE0526E39505192554@orsmsx419.amr.corp.intel.com>
	 <20080921090549.GK27426@8bytes.org>
Content-Type: text/plain
Date: Mon, 22 Sep 2008 09:26:46 -0700
Message-Id: <1222100806.4000.25.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-09-21 at 11:05 +0200, Joerg Roedel wrote:
> can you add an entry to the MAINTAINERs file for Intel IOMMU? I found
> it difficult to find the responsible person for this thread.

I was trying to avoid doing that until I've actually acquired enough
clue for it to be meaningful. I'll be home from Portland next week, and
working to achieve that, with the shiny new hardware that arrived just
before I left.

I'm also planning to create a separate git tree for iommu work, where we
can all have direct access. It doesn't really live in the x86 tree.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

