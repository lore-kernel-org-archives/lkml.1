Return-Path: <linux-kernel-owner+w=401wt.eu-S1756489AbZJZTrd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756489AbZJZTrd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 15:47:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754835AbZJZTrc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 15:47:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34273 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755017AbZJZTr3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 15:47:29 -0400
Message-ID: <4AE5FD77.5070709@redhat.com>
Date: Mon, 26 Oct 2009 15:50:15 -0400
From: Don Dutile <ddutile@redhat.com>
Reply-To: ddutile@redhat.com
User-Agent: Thunderbird 2.0.0.18 (X11/20081113)
MIME-Version: 1.0
To: Stefan Assmann <sassmann@redhat.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: [PATCH] PCI hotplug: change PCI nomenclature
References: <4AE5A7CE.2080206@redhat.com>
In-Reply-To: <4AE5A7CE.2080206@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Assmann wrote:
> Change PCI nomenclature according to
> http://www.pcisig.com/developers/procedures/logos/Trademark_and_Logo_Usage_Guidelines_updated_112206.pdf.
> 
> Signed-off-by: Stefan Assmann <sassmann@redhat.com>
> ---
> diff --git a/drivers/pci/hotplug/pci_hotplug_core.c b/drivers/pci/hotplug/pci_hotplug_core.c
> index 0325d98..38183a5 100644
> --- a/drivers/pci/hotplug/pci_hotplug_core.c
> +++ b/drivers/pci/hotplug/pci_hotplug_core.c
> @@ -68,26 +68,26 @@ static DEFINE_MUTEX(pci_hp_mutex);
>  static char *pci_bus_speed_strings[] = {
>  	"33 MHz PCI",		/* 0x00 */
>  	"66 MHz PCI",		/* 0x01 */
> -	"66 MHz PCIX", 		/* 0x02 */
> -	"100 MHz PCIX",		/* 0x03 */
> -	"133 MHz PCIX",		/* 0x04 */
> +	"66 MHz PCI-X",		/* 0x02 */
> +	"100 MHz PCI-X",	/* 0x03 */
> +	"133 MHz PCI-X",	/* 0x04 */
>  	NULL,			/* 0x05 */
>  	NULL,			/* 0x06 */
>  	NULL,			/* 0x07 */
>  	NULL,			/* 0x08 */
> -	"66 MHz PCIX 266",	/* 0x09 */
> -	"100 MHz PCIX 266",	/* 0x0a */
> -	"133 MHz PCIX 266",	/* 0x0b */
> +	"66 MHz PCI-X 266",	/* 0x09 */
> +	"100 MHz PCI-X 266",	/* 0x0a */
> +	"133 MHz PCI-X 266",	/* 0x0b */
>  	NULL,			/* 0x0c */
>  	NULL,			/* 0x0d */
>  	NULL,			/* 0x0e */
>  	NULL,			/* 0x0f */
>  	NULL,			/* 0x10 */
> -	"66 MHz PCIX 533",	/* 0x11 */
> -	"100 MHz PCIX 533",	/* 0x12 */
> -	"133 MHz PCIX 533",	/* 0x13 */
> -	"2.5 GT/s PCI-E",	/* 0x14 */
> -	"5.0 GT/s PCI-E",	/* 0x15 */
> +	"66 MHz PCI-X 533",	/* 0x11 */
> +	"100 MHz PCI-X 533",	/* 0x12 */
> +	"133 MHz PCI-X 533",	/* 0x13 */
> +	"2.5 GT/s PCIe",	/* 0x14 */
> +	"5.0 GT/s PCIe",	/* 0x15 */
>  };
> 
>  #ifdef CONFIG_HOTPLUG_PCI_CPCI

Signed-off-by: Donald Dutile <ddutile@redhat.com>
