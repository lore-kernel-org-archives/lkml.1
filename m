Return-Path: <linux-kernel-owner+w=401wt.eu-S1753302AbYJTHnl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302AbYJTHnl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 03:43:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751510AbYJTHnc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 03:43:32 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53231 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbYJTHnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 03:43:31 -0400
Subject: Re: [ANNOUNCE] iommu-2.6.git tree
From: David Woodhouse <dwmw2@infradead.org>
To: Joerg Roedel <joro@8bytes.org>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       fenghua.yu@intel.com, tony.luck@intel.com, suresh.b.siddha@intel.com,
       sfr@canb.auug.org.au, andreas.herrmann3@amd.com,
       joseph.cihula@intel.com, akpm@linux-foundation.org,
       jbarnes@virtuousgeek.org, tglx@linutronix.de,
       torvalds@linux-foundation.org, mingo@elte.hu
In-Reply-To: <20081019211449.GG21841@8bytes.org>
References: <1224343843.6770.1378.camel@macbook.infradead.org>
	 <20081019111203.GB29705@8bytes.org>
	 <1224415198.6770.1464.camel@macbook.infradead.org>
	 <20081019211449.GG21841@8bytes.org>
Content-Type: text/plain
Date: Mon, 20 Oct 2008 08:43:25 +0100
Message-Id: <1224488605.6770.1522.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-10-19 at 23:14 +0200, Joerg Roedel wrote:
> This is a reason for a seperate Intel IOMMU tree which is pulled by
> Linus. But I don't think that this is a reason to take over control of
> all IOMMU development.

I have no intention of taking over control of anything, if I can
possibly avoid it. The _less_ patch-monkey work I have to do, the
happier I'll be. There's more to life than Jon's patch statistics.

I'm perfectly happy for Ingo to pull my tree into his, as I keep saying.
As long as it gets into linux-next, that's fine.

When I discussed it with Thomas a few weeks ago, he seemed to be
suggesting that creating a new tree was the best thing to do, but I'm
more than happy to adapt.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

