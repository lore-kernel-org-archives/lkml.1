Return-Path: <linux-kernel-owner+w=401wt.eu-S1752198AbYJRPwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198AbYJRPwV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 11:52:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750899AbYJRPwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 11:52:14 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40452 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824AbYJRPwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 11:52:13 -0400
Subject: Re: [ANNOUNCE] iommu-2.6.git tree
From: David Woodhouse <dwmw2@infradead.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       joerg.roedel@amd.com, tglx@linutronix.de, mingo@elte.hu,
       fujita.tomonori@lab.ntt.co.jp, andreas.herrmann3@amd.com,
       joseph.cihula@intel.com, fenghua.yu@intel.com, jbarnes@virtuousgeek.org,
       tony.luck@intel.com, suresh.b.siddha@intel.com,
       torvalds@linux-foundation.org, akpm@linux-foundation.org
In-Reply-To: <20081019024328.2cda973e.sfr@canb.auug.org.au>
References: <1224343843.6770.1378.camel@macbook.infradead.org>
	 <20081019024328.2cda973e.sfr@canb.auug.org.au>
Content-Type: text/plain
Date: Sat, 18 Oct 2008 16:51:37 +0100
Message-Id: <1224345097.6770.1389.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-10-19 at 02:43 +1100, Stephen Rothwell wrote:
> Sure (I assume the "master" branch).

Yes. I don't use branches in public-facing repositories -- it's much
better just to have separate trees. 

>  However, I already have a tree in -next called iommu.  It is one of the 
> tip auto branches (auto-iommu-next) and is currently empty.  So do I name
> this one dwmw2-iommu, or has Ingo finished with the other one?

I believe the plan is that Ingo has finished with the other one and we
use the new one instead, yes.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

