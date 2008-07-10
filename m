Return-Path: <linux-kernel-owner+w=401wt.eu-S1756198AbYGJAd0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198AbYGJAd0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 20:33:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752759AbYGJAdT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 20:33:19 -0400
Received: from igw2.br.ibm.com ([32.104.18.25]:41807 "EHLO igw2.br.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752378AbYGJAdS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 20:33:18 -0400
Subject: Re: [PATCH] tpm: add Intel TPM TIS device HID
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
To: Marcel Selhorst <tpm@selhorst.net>
Cc: Marcin Obara <marcin_obara@users.sourceforge.net>,
       tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <486B4460.5000702@selhorst.net>
References: <alpine.DEB.1.00.0806281913410.7076@ip-195-3-221-75.vnet.pl>
	 <486B4460.5000702@selhorst.net>
Content-Type: text/plain
Date: Wed, 09 Jul 2008 21:31:17 -0300
Message-Id: <1215649878.25273.73.camel@blackbox>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>

On Wed, 2008-07-02 at 11:03 +0200, Marcel Selhorst wrote:
> Acked-by: Marcel Selhorst <tpm@selhorst.net>
> 
> Marcin Obara schrieb:
> > This patch adds Intel TPM TIS device HID :  ICO0102
> > 
> > Signed-off-by: Marcin Obara <marcin_obara@users.sourceforge.net>
> > 
> > --- linux_tpm/drivers/char/tpm/tpm_tis.c	2008-06-05 20:51:13.000000000 +0200
> > +++ linux_intel/drivers/char/tpm/tpm_tis.c	2008-06-25 06:31:39.000000000 +0200
> > @@ -623,6 +623,7 @@ static struct pnp_device_id tpm_pnp_tbl[
> >  	{"IFX0102", 0},		/* Infineon */
> >  	{"BCM0101", 0},		/* Broadcom */
> >  	{"NSC1200", 0},		/* National */
> > +	{"ICO0102", 0},		/* Intel */
> >  	/* Add new here */
> >  	{"", 0},		/* User Specified */
> >  	{"", 0}			/* Terminator */
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

