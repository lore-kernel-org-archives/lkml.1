Return-Path: <linux-kernel-owner+w=401wt.eu-S1759725AbZBLOwd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759725AbZBLOwd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 09:52:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758747AbZBLOwK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 09:52:10 -0500
Received: from 8bytes.org ([88.198.83.132]:51713 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758609AbZBLOwJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 09:52:09 -0500
Date: Thu, 12 Feb 2009 15:52:08 +0100
From: Joerg Roedel <joro@8bytes.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Joerg Roedel <joerg.roedel@amd.com>, fujita.tomonori@lab.ntt.co.jp,
       iommu@lists.linux-foundation.org, mingo@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/16] dma-debug: add checking for map/unmap_page/single
Message-ID: <20090212145208.GC2125@8bytes.org>
References: <1232376423-11067-1-git-send-email-joerg.roedel@amd.com> <1232376423-11067-10-git-send-email-joerg.roedel@amd.com> <1233867982.3548.697.camel@macbook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1233867982.3548.697.camel@macbook.infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 05, 2009 at 09:06:22PM +0000, David Woodhouse wrote:
> On Mon, 2009-01-19 at 15:46 +0100, Joerg Roedel wrote:
> >  
> > +static inline void debug_dma_map_page(struct device *dev, struct page *page,
> > +                                     size_t offset size_t size,
> 
> A missing comma between those two arguments...       ^

Ups, fixed. Thanks.

