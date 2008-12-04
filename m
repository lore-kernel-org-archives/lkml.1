Return-Path: <linux-kernel-owner+w=401wt.eu-S1757893AbYLDS12@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757893AbYLDS12 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 13:27:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756002AbYLDS1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 13:27:09 -0500
Received: from ns1.suse.de ([195.135.220.2]:52104 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756200AbYLDS1H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 13:27:07 -0500
Date: Thu, 4 Dec 2008 10:05:25 -0800
From: Greg KH <gregkh@suse.de>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: avi@redhat.com, mingo@redhat.com, dwmw2@infradead.org,
       weidong.han@intel.com, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 03/11] add frontend implementation for the IOMMU API
Message-ID: <20081204180525.GA30024@suse.de>
References: <20081204172142.GH12816@amd.com> <1228411736-22644-4-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1228411736-22644-4-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04, 2008 at 06:28:48PM +0100, Joerg Roedel wrote:
> This API can be used by KVM for accessing different types of IOMMUs to
> do device passthrough to guests. Beside that this API can also be used
> by device drivers to map non-linear host memory into dma-linear
> addresses to prevent sgather-gather DMA. UIO may be another user for
> this API.
> 
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>

Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

