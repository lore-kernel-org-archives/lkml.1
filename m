Return-Path: <linux-kernel-owner+w=401wt.eu-S1751659AbXLRHuF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751659AbXLRHuF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 02:50:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751480AbXLRHty
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 02:49:54 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:47503 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750886AbXLRHtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 02:49:53 -0500
Message-ID: <47677B9D.2070507@sgi.com>
Date: Tue, 18 Dec 2007 08:49:49 +0100
From: Jes Sorensen <jes@sgi.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Tony Luck <tony.luck@intel.com>, linux-altix@sgi.com,
       linux-ia64@vger.kernel.org
Subject: Re: [PATCH] arch/ia64/: Spelling fixes
References: <1197919875-5288-6-git-send-email-joe@perches.com>
In-Reply-To: <1197919875-5288-6-git-send-email-joe@perches.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe,

I'm curious, do you have a patch that actually fixes something and adds
value to the code? Maybe you could include the spelling fix with that to
improve the S/N ratio?

In addition, posting a patch with no commit comment is no good, please
read through Documentation/SubmittingPatches before posting an update
to this.

Thanks,
Jes


Joe Perches wrote:
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  arch/ia64/sn/pci/tioce_provider.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/ia64/sn/pci/tioce_provider.c b/arch/ia64/sn/pci/tioce_provider.c
> index cee9379..e1a3e19 100644
> --- a/arch/ia64/sn/pci/tioce_provider.c
> +++ b/arch/ia64/sn/pci/tioce_provider.c
> @@ -41,7 +41,7 @@
>   *	} else
>   *		do desired mmr access
>   *
> - * According to hw, we can use reads instead of writes to the above addres
> + * According to hw, we can use reads instead of writes to the above address
>   *
>   * Note this WAR can only to be used for accessing internal MMR's in the
>   * TIOCE Coretalk Address Range 0x0 - 0x07ff_ffff.  This includes the

