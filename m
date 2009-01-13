Return-Path: <linux-kernel-owner+w=401wt.eu-S1759127AbZAMJAF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759127AbZAMJAF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 04:00:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752695AbZAMI7u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 03:59:50 -0500
Received: from casper.infradead.org ([85.118.1.10]:54808 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071AbZAMI7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 03:59:49 -0500
Subject: Re: [PATCH 03/16] dma-debug: add hash functions for
 dma_debug_entries
From: David Woodhouse <dwmw2@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joerg Roedel <joerg.roedel@amd.com>, linux-kernel@vger.kernel.org,
       mingo@redhat.com, fujita.tomonori@lab.ntt.co.jp, netdev@vger.kernel.org,
       iommu@lists.linux-foundation.org
In-Reply-To: <20090113005118.82f5037b.akpm@linux-foundation.org>
References: <1231517970-20288-1-git-send-email-joerg.roedel@amd.com>
	 <1231517970-20288-4-git-send-email-joerg.roedel@amd.com>
	 <20090113005118.82f5037b.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 13 Jan 2009 08:59:39 +0000
Message-Id: <1231837179.25018.2816.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 (2.24.2-2.fc10) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-01-13 at 00:51 -0800, Andrew Morton wrote:
> This all looks like an exotically large amount of code for a debug
> thingy?

Perhaps so, but it's a useful debug thingy which lets us debug _very_
common problems in drivers, which many people are unlikely to notice
without this 'assistance'. 

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

