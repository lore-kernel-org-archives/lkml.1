Return-Path: <linux-kernel-owner+w=401wt.eu-S1753285AbZD2H3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285AbZD2H3W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 03:29:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755308AbZD2H2w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 03:28:52 -0400
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:22319 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754006AbZD2H2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 03:28:50 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnMCAJue90nUpjDs/2dsb2JhbAAIzjCDdAU
Message-ID: <49F801AF.1060404@246tNt.com>
Date: Wed, 29 Apr 2009 09:28:47 +0200
From: Sylvain Munaut <tnt@246tNt.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090118)
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powerpc: Update MPC5xxx and Xilinx Virtex maintainer
 entries
References: <20090428165015.1410.47926.stgit@localhost.localdomain>
In-Reply-To: <20090428165015.1410.47926.stgit@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant Likely wrote:
> From: Grant Likely <grant.likely@secretlab.ca>
> 
> - Add git tree URLs
> - Drop Sylvain from the 5xxx maintainers list.  He hasn't been active
>   for a while now.
> 
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>

Confirmed.

> ---
> 
>  MAINTAINERS |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index ef03abe..4a8d367 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -3434,11 +3434,10 @@ L:	linuxppc-dev@ozlabs.org
>  S:	Maintained
>  
>  LINUX FOR POWERPC EMBEDDED MPC5XXX
> -P:	Sylvain Munaut
> -M:	tnt@246tNt.com
>  P:	Grant Likely
>  M:	grant.likely@secretlab.ca
>  L:	linuxppc-dev@ozlabs.org
> +T:	git git://git.secretlab.ca/git/linux-2.6.git
>  S:	Maintained
>  
>  LINUX FOR POWERPC EMBEDDED PPC4XX
> @@ -3456,6 +3455,7 @@ P:	Grant Likely
>  M:	grant.likely@secretlab.ca
>  W:	http://wiki.secretlab.ca/index.php/Linux_on_Xilinx_Virtex
>  L:	linuxppc-dev@ozlabs.org
> +T:	git git://git.secretlab.ca/git/linux-2.6.git
>  S:	Maintained
>  
>  LINUX FOR POWERPC EMBEDDED PPC8XX
> 

