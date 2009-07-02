Return-Path: <linux-kernel-owner+w=401wt.eu-S1751210AbZGBEK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751210AbZGBEK2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 00:10:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750850AbZGBEKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 00:10:21 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:43618 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750826AbZGBEKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 00:10:21 -0400
Message-ID: <4A4C332E.7050808@snapgear.com>
Date: Thu, 02 Jul 2009 14:10:22 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: linux-kernel@vger.kernel.org, trivial@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 03/62] arch/m68knommu/kernel/time.c: Remove unnecessary
 semicolons
References: <cover.1246173664.git.joe@perches.com> <fde8f173810c514e9a97bd1ece829d7a02d4bb41.1246173680.git.joe@perches.com>
In-Reply-To: <fde8f173810c514e9a97bd1ece829d7a02d4bb41.1246173680.git.joe@perches.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

Joe Perches wrote:
> Signed-off-by: Joe Perches <joe@perches.com>

Thanks, applied.

Regards
Greg



> ---
>  arch/m68knommu/kernel/time.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/m68knommu/kernel/time.c b/arch/m68knommu/kernel/time.c
> index d182b2f..c2aa717 100644
> --- a/arch/m68knommu/kernel/time.c
> +++ b/arch/m68knommu/kernel/time.c
> @@ -69,7 +69,7 @@ static unsigned long read_rtc_mmss(void)
>  	if ((year += 1900) < 1970)
>  		year += 100;
>  
> -	return  mktime(year, mon, day, hour, min, sec);;
> +	return  mktime(year, mon, day, hour, min, sec);
>  }
>  
>  unsigned long read_persistent_clock(void)

-- 
------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
