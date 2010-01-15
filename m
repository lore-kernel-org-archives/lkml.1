Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756757Ab0AOKbT (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 05:31:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755705Ab0AOKbS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 05:31:18 -0500
Received: from cantor.suse.de ([195.135.220.2]:44886 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753159Ab0AOKbR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 05:31:17 -0500
Date: Fri, 15 Jan 2010 11:31:16 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix a typo in pci-dma.c
In-Reply-To: <1263536176-9154-1-git-send-email-justinmattock@gmail.com>
Message-ID: <alpine.LNX.2.00.1001151131070.30977@pobox.suse.cz>
References: <1263536176-9154-1-git-send-email-justinmattock@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Jan 2010, Justin P. Mattock wrote:

> Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
> ---
>  arch/x86/kernel/pci-dma.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
> index 75e14e2..eec33a7 100644
> --- a/arch/x86/kernel/pci-dma.c
> +++ b/arch/x86/kernel/pci-dma.c
> @@ -38,7 +38,7 @@ int iommu_detected __read_mostly = 0;
>   * This variable becomes 1 if iommu=pt is passed on the kernel command line.
>   * If this variable is 1, IOMMU implementations do no DMA translation for
>   * devices and allow every device to access to whole physical memory. This is
> - * useful if a user want to use an IOMMU only for KVM device assignment to
> + * useful if a user wants to use an IOMMU only for KVM device assignment to
>   * guests and not for driver dma translation.
>   */

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
