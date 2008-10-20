Return-Path: <linux-kernel-owner+w=401wt.eu-S1752663AbYJTJIM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752663AbYJTJIM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 05:08:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751011AbYJTJH7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 05:07:59 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49883 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbYJTJH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 05:07:59 -0400
Subject: Re: [ANNOUNCE] iommu-2.6.git tree
From: David Woodhouse <dwmw2@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Joerg Roedel <joro@8bytes.org>, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, fenghua.yu@intel.com, tony.luck@intel.com,
       suresh.b.siddha@intel.com, sfr@canb.auug.org.au,
       andreas.herrmann3@amd.com, joseph.cihula@intel.com,
       akpm@linux-foundation.org, jbarnes@virtuousgeek.org, tglx@linutronix.de,
       torvalds@linux-foundation.org
In-Reply-To: <20081020085217.GF798@elte.hu>
References: <1224343843.6770.1378.camel@macbook.infradead.org>
	 <20081019111203.GB29705@8bytes.org>
	 <1224415198.6770.1464.camel@macbook.infradead.org>
	 <20081019211449.GG21841@8bytes.org>
	 <1224488605.6770.1522.camel@macbook.infradead.org>
	 <20081020085217.GF798@elte.hu>
Content-Type: text/plain
Date: Mon, 20 Oct 2008 10:07:43 +0100
Message-Id: <1224493663.6770.1538.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-10-20 at 10:52 +0200, Ingo Molnar wrote:
> What was not fine for you was to declare tip/auto-iommu-next the 'old' 
> tree and to request a zapping of linux-next's auto-iommu-next 
> integration, unilaterally.

I didn't ask for it to be removed. Stephen asked if he should remove it,
and given my conversation with Thomas I said that I _believe_ that was
the plan. After all, the old tree already didn't seem to exist any more,
even though there were outstanding patches which need to be merged. But
I made sure I didn't give a definitive answer to Stephen's question, and
I made sure you and Thomas were both on Cc when I said it.

If that was offensive to you, then I apologise.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

