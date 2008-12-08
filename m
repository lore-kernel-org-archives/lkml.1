Return-Path: <linux-kernel-owner+w=401wt.eu-S1752426AbYLHNFk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752426AbYLHNFk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 08:05:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753932AbYLHNFX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 08:05:23 -0500
Received: from 8bytes.org ([88.198.83.132]:34822 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753849AbYLHNFV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 08:05:21 -0500
Date: Mon, 8 Dec 2008 14:05:19 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: avi@redhat.com, mingo@redhat.com, dwmw2@infradead.org, gregkh@suse.de,
       weidong.han@intel.com, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCHSETS] KVM device passthrough support with AMD IOMMU
Message-ID: <20081208130518.GP29705@8bytes.org>
References: <20081204172142.GH12816@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081204172142.GH12816@amd.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04, 2008 at 06:21:42PM +0100, Joerg Roedel wrote:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-iommu.git kvm-amd-iommu
>

FYI, I just updated the branch above. I added a cleanup function which
removes the devices from a protection domain before it is released.

Joerg
