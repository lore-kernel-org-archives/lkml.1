Return-Path: <linux-kernel-owner+w=401wt.eu-S1754752AbYLJOWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752AbYLJOWd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 09:22:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751604AbYLJOWY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 09:22:24 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:55220 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbYLJOWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 09:22:23 -0500
Subject: Re: [PATCHSETS #2] KVM device passthrough support with AMD IOMMU
From: David Woodhouse <dwmw2@infradead.org>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Avi Kivity <avi@redhat.com>, mingo@redhat.com, weidong.han@intel.com,
       torvalds@linux-foundation.org, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org
In-Reply-To: <20081210141131.GB12816@amd.com>
References: <20081209141143.GW12816@amd.com> <493F8D90.40205@redhat.com>
	 <20081210141131.GB12816@amd.com>
Content-Type: text/plain
Date: Wed, 10 Dec 2008 14:22:08 +0000
Message-Id: <1228918928.21454.27.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 (2.24.2-1.fc10) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-12-10 at 15:11 +0100, Joerg Roedel wrote:
> So now its open how this will be merged alltogether. We can merge it in
> three steps (first from Dave's tree, then Avi and at last my IOMMU
> updates which has to happen in that order).
> The other option is to merge this all with one pull-request I send to
> Linus. It should not conflict with your updates Avi because all these
> changes apply also cleanly to current linus/master.
> Is this acceptable for everyone?
> 
> David, its important to hear your opinion on that because this single
> pull-request would include all VT-d updates you have queued in your
> tree? Is this ok for you?

Yes, that's fine by me. Should I apply patches 1-14 of Weidong's patch
set from Monday first? Or just let you do that?

-- 
dwmw2

