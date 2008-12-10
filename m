Return-Path: <linux-kernel-owner+w=401wt.eu-S1757484AbYLJStQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757484AbYLJStQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 13:49:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754003AbYLJSs6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 13:48:58 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:51649 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753650AbYLJSs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 13:48:57 -0500
Subject: Re: [PATCHSETS #2] KVM device passthrough support with AMD IOMMU
From: David Woodhouse <dwmw2@infradead.org>
To: Joerg Roedel <joerg.roedel@amd.com>, Mike Day <ncmike@ncultra.org>
Cc: Avi Kivity <avi@redhat.com>, mingo@redhat.com, weidong.han@intel.com,
       torvalds@linux-foundation.org, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org
In-Reply-To: <20081210184240.GH12816@amd.com>
References: <20081209141143.GW12816@amd.com> <493F8D90.40205@redhat.com>
	 <20081210141131.GB12816@amd.com>
	 <1228918928.21454.27.camel@macbook.infradead.org>
	 <20081210142525.GC12816@amd.com>
	 <1228933475.23842.70.camel@macbook.infradead.org>
	 <20081210184240.GH12816@amd.com>
Content-Type: text/plain
Date: Wed, 10 Dec 2008 18:48:23 +0000
Message-Id: <1228934903.23842.75.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 (2.24.2-1.fc10) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-12-10 at 19:42 +0100, Joerg Roedel wrote:
> Ok, I add it, thanks. Who is the author, Mike or you?

Might as well attribute it to Mike; he spotted it.

-- 
dwmw2

