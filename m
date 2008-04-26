Return-Path: <linux-kernel-owner+w=401wt.eu-S1753287AbYDZE52@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287AbYDZE52 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 00:57:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751553AbYDZE5T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 00:57:19 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:22887 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445AbYDZE5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 00:57:18 -0400
Date: Fri, 25 Apr 2008 21:50:37 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Matt LaPlante <kernel1@cyberdogtech.com>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH] 2.6.25-git7 - Kconfig Cleanup
Message-Id: <20080425215037.0b7cead1.randy.dunlap@oracle.com>
In-Reply-To: <20080425232848.b4200d21.kernel1@cyberdogtech.com>
References: <20080425232848.b4200d21.kernel1@cyberdogtech.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Apr 2008 23:28:48 -0500 Matt LaPlante wrote:

> Fix misc small typos/grammar in Kconfigs for 2.6.25-git7.
> 
> Signed-off-by: Matt LaPlante <kernel1@cyberdogtech.com>
> --
> 
> diff -ru a/arch/cris/arch-v32/Kconfig b/arch/cris/arch-v32/Kconfig
> --- a/arch/cris/arch-v32/Kconfig	2008-04-16 21:49:44.000000000 -0500
> +++ b/arch/cris/arch-v32/Kconfig	2008-04-25 22:13:14.000000000 -0500
> @@ -27,8 +27,8 @@
>  	bool "Use one LED group"
>  	help
>  	  Select this if you want one Ethernet LED group. This LED group
> -	  can be used for one or more Ethernet interfaces. However, it is
> -	  recomended that each Ethernet interface use a dedicated LED group.
> +	  can be used for one or more Ethernet interfaces, however it is

That comma creates a run-on sentence.  Period was better.

Other than that, looks good.  Thanks.

> +	  recommended that each Ethernet interface use a dedicated LED group.
>  
>  config	ETRAX_NBR_LED_GRP_TWO
>  	bool "Use two LED groups"

---
~Randy
