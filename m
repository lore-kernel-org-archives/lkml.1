Return-Path: <linux-kernel-owner+w=401wt.eu-S1752826AbZJZRyk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826AbZJZRyk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 13:54:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752485AbZJZRyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 13:54:39 -0400
Received: from khc.piap.pl ([195.187.100.11]:40550 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752423AbZJZRyi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 13:54:38 -0400
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Stefan Assmann <sassmann@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Don Dutile <ddutile@redhat.com>
Subject: Re: [PATCH] PCI hotplug: change PCI nomenclature
References: <4AE5A7CE.2080206@redhat.com>
Date: Mon, 26 Oct 2009 18:54:40 +0100
In-Reply-To: <4AE5A7CE.2080206@redhat.com> (Stefan Assmann's message of "Mon,
	26 Oct 2009 14:44:46 +0100")
Message-ID: <m38wey59cv.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Assmann <sassmann@redhat.com> writes:

> +++ b/drivers/pci/hotplug/pci_hotplug_core.c

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

Seems perfect now.
-- 
Krzysztof Halasa
