Return-Path: <linux-kernel-owner+w=401wt.eu-S935187AbZKYXW4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935187AbZKYXW4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 18:22:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935100AbZKYXWz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 18:22:55 -0500
Received: from cantor.suse.de ([195.135.220.2]:37657 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934896AbZKYXWx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 18:22:53 -0500
Date: Thu, 26 Nov 2009 00:22:58 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Rudy Matela <rudy.matela@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Spelling correction in HDLC/Frame Relay support
 routines
In-Reply-To: <20091125132020.GA22390@vacuum.larces.uece.br>
Message-ID: <alpine.LSU.2.00.0911260022460.6953@wotan.suse.de>
References: <20091125132020.GA22390@vacuum.larces.uece.br>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Nov 2009, Rudy Matela wrote:

> Spelling correction in HDLC/Frame Relay support routines
> 
> Changed: /* the listed is sorted */
> To: /* the list is sorted */
> 
> Signed-off-by: Rudy Matela <rudy.matela@gmail.com>
> ---
> 
> diff --git a/drivers/net/wan/hdlc_fr.c b/drivers/net/wan/hdlc_fr.c
> index 840cff7..4d4c543 100644
> --- a/drivers/net/wan/hdlc_fr.c
> +++ b/drivers/net/wan/hdlc_fr.c
> @@ -182,7 +182,7 @@ static inline pvc_device* find_pvc(hdlc_device *hdlc, u16 dlci)
>  		if (pvc->dlci == dlci)
>  			return pvc;
>  		if (pvc->dlci > dlci)
> -			return NULL; /* the listed is sorted */
> +			return NULL; /* the list is sorted */
>  		pvc = pvc->next;

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
