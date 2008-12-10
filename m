Return-Path: <linux-kernel-owner+w=401wt.eu-S1755359AbYLJOYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359AbYLJOYW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 09:24:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752301AbYLJOYI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 09:24:08 -0500
Received: from mx2.redhat.com ([66.187.237.31]:57482 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751604AbYLJOYH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 09:24:07 -0500
Message-ID: <493FD0FC.9010406@redhat.com>
Date: Wed, 10 Dec 2008 16:23:56 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: dwmw2@infradead.org, mingo@redhat.com, weidong.han@intel.com,
       torvalds@linux-foundation.org, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCHSETS #2] KVM device passthrough support with AMD IOMMU
References: <20081209141143.GW12816@amd.com> <493F8D90.40205@redhat.com> <20081210141131.GB12816@amd.com>
In-Reply-To: <20081210141131.GB12816@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Roedel wrote:
> So now its open how this will be merged alltogether. We can merge it in
> three steps (first from Dave's tree, then Avi and at last my IOMMU
> updates which has to happen in that order).
> The other option is to merge this all with one pull-request I send to
> Linus. It should not conflict with your updates Avi because all these
> changes apply also cleanly to current linus/master.
> Is this acceptable for everyone?
>   

Okay for me.

-- 
error compiling committee.c: too many arguments to function

