Return-Path: <linux-kernel-owner+w=401wt.eu-S1761329AbXKNTKx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761329AbXKNTKx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 14:10:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754751AbXKNTKo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 14:10:44 -0500
Received: from cantor.suse.de ([195.135.220.2]:33354 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753699AbXKNTKn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 14:10:43 -0500
Date: Wed, 14 Nov 2007 10:58:26 -0800
From: Greg KH <gregkh@suse.de>
To: Mark Lord <liml@rtr.ca>
Cc: Allen Martin <AMartin@nvidia.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Jeff Garzik <jeff@garzik.org>, Riki Oktarianto <rkoktarianto@gmail.com>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH] Add quirk to set AHCI mode on ICH boards
Message-ID: <20071114185826.GA1384@suse.de>
References: <20071113152727.45b71939@the-village.bc.nu> <F72FA20C31DD4F4C997B91C5B3690A095054A7@hqemmail07.nvidia.com> <473B4271.3000201@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <473B4271.3000201@rtr.ca>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2007 at 01:46:09PM -0500, Mark Lord wrote:
> Allen Martin wrote:
> ..
>> Errata for which there is an SBIOS workaround are generally only
>> released to BIOS vendors and under NDA.  If Linux users were impacted by
>> such a bug we would most likely release a patch, but a much more likely
> ..
>
> All of that silly secrecy harms your company and your customers.
> You really should find a way to make the full information available
> to all O/S providers.  In the case of Linux, this costs nothing
> but a willingness on your part.

Actually, we (Linux developers) can sign NDAs if that is what the
manufacturer needs in order for us to be able to get this information.

If that is what nvidia requires, please let me know and I can set up the
proper paperwork so that we can get this needed information.

thanks,

greg k-h
