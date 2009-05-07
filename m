Return-Path: <linux-kernel-owner+w=401wt.eu-S1761213AbZEGRFD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761213AbZEGRFD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 13:05:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754304AbZEGREw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 13:04:52 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53881 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754299AbZEGREv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 13:04:51 -0400
Date: Thu, 7 May 2009 13:04:49 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       mingo@redhat.com, airlied@linux.ie
Subject: Re: IOMMU and graphics cards
Message-ID: <20090507170449.GA14681@infradead.org>
References: <20090428150531.GZ17438@amd.com> <1240932530.2567.91.camel@macbook.infradead.org> <20090428160448.GA17438@amd.com> <20090507164742V.fujita.tomonori@lab.ntt.co.jp> <20090507100114.GF4059@amd.com> <1241691721.3531.73.camel@macbook.infradead.org> <20090507121535.GH4059@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090507121535.GH4059@amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 07, 2009 at 02:15:35PM +0200, Joerg Roedel wrote:
> Well, it is not that simple. Having no workaround at all will not result
> in working proprietary drivers.

Which could be considered at not too bad thing anyway.

> More likely is that distros just disable
> the IOMMU because their customers want to use these drivers for working
> 3d acceleration.

Maybe Ubuntu :)

