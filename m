Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520Ab0BGMJu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 07:09:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23264 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753616Ab0BGMJs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 07:09:48 -0500
Message-ID: <4B6EAD80.5080508@redhat.com>
Date: Sun, 07 Feb 2010 14:09:36 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>,
       David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org,
       iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/11] kvm: Introduce kvm_host_page_size
References: <1264678682-30655-1-git-send-email-joerg.roedel@amd.com> <1264678682-30655-6-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1264678682-30655-6-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2010 01:37 PM, Joerg Roedel wrote:
> This patch introduces a generic function to find out the
> host page size for a given gfn. This function is needed by
> the kvm iommu code. This patch also simplifies the x86
> host_mapping_level function.
>    

Applied to kvm.git since this makes sense independently of the rest of 
your patchset.

-- 
error compiling committee.c: too many arguments to function

