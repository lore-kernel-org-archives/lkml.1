Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755120Ab0BGON7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 09:13:59 -0500
Received: from 8bytes.org ([88.198.83.132]:47020 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750798Ab0BGON6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 09:13:58 -0500
Date: Sun, 7 Feb 2010 15:13:57 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Avi Kivity <avi@redhat.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org,
       iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/11] kvm: Introduce kvm_host_page_size
Message-ID: <20100207141357.GB23725@8bytes.org>
References: <1264678682-30655-1-git-send-email-joerg.roedel@amd.com> <1264678682-30655-6-git-send-email-joerg.roedel@amd.com> <4B6EAD80.5080508@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B6EAD80.5080508@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 07, 2010 at 02:09:36PM +0200, Avi Kivity wrote:
> On 01/28/2010 01:37 PM, Joerg Roedel wrote:
>> This patch introduces a generic function to find out the
>> host page size for a given gfn. This function is needed by
>> the kvm iommu code. This patch also simplifies the x86
>> host_mapping_level function.
>>    
>
> Applied to kvm.git since this makes sense independently of the rest of  
> your patchset.

Yes, makes sense for this patch. I will rebase my branch once you pushed
it out.

	Joerg

