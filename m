Return-Path: <linux-kernel-owner+w=401wt.eu-S1758029AbYGBJI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758029AbYGBJI4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 05:08:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752910AbYGBJIp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 05:08:45 -0400
Received: from smtprelay04.ispgateway.de ([80.67.18.16]:59655 "EHLO
	smtprelay04.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464AbYGBJIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 05:08:44 -0400
X-Greylist: delayed 313 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Jul 2008 05:08:44 EDT
Message-ID: <486B4460.5000702@selhorst.net>
Date: Wed, 02 Jul 2008 11:03:28 +0200
From: Marcel Selhorst <tpm@selhorst.net>
User-Agent: Thunderbird 2.0.0.14 (X11/20080618)
MIME-Version: 1.0
To: Marcin Obara <marcin_obara@users.sourceforge.net>
CC: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tpm: add Intel TPM TIS device HID
References: <alpine.DEB.1.00.0806281913410.7076@ip-195-3-221-75.vnet.pl>
In-Reply-To: <alpine.DEB.1.00.0806281913410.7076@ip-195-3-221-75.vnet.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.1-5; AVE: 7.8.0.59; VDF: 7.0.5.34; host: mail)
X-Df-Sender: 174499
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Marcel Selhorst <tpm@selhorst.net>

Marcin Obara schrieb:
> This patch adds Intel TPM TIS device HID :  ICO0102
> 
> Signed-off-by: Marcin Obara <marcin_obara@users.sourceforge.net>
> 
> --- linux_tpm/drivers/char/tpm/tpm_tis.c	2008-06-05 20:51:13.000000000 +0200
> +++ linux_intel/drivers/char/tpm/tpm_tis.c	2008-06-25 06:31:39.000000000 +0200
> @@ -623,6 +623,7 @@ static struct pnp_device_id tpm_pnp_tbl[
>  	{"IFX0102", 0},		/* Infineon */
>  	{"BCM0101", 0},		/* Broadcom */
>  	{"NSC1200", 0},		/* National */
> +	{"ICO0102", 0},		/* Intel */
>  	/* Add new here */
>  	{"", 0},		/* User Specified */
>  	{"", 0}			/* Terminator */
> 
