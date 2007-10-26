Return-Path: <linux-kernel-owner+w=401wt.eu-S1761665AbXJZV6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761665AbXJZV6V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 17:58:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751091AbXJZV6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 17:58:09 -0400
Received: from alephnull.demon.nl ([83.160.184.112]:53342 "EHLO
	xi.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798AbXJZV6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 17:58:07 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=1148133259;
	d=wantstofly.org;
	h=date:from:to:cc:subject:message-id:mime-version:content-type:
	content-disposition:in-reply-to:user-agent;
	b=QIIW6CVatFE0G3sQaoXDsldX++v2GdzIjYOsZvOWMRU6czU1X3c+lLG1N5zz4
	cn9ZPswq9GvD49dg+vsQv/O5Q==
Date: Fri, 26 Oct 2007 23:58:05 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: LKML <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       rmk@arm.linux.org.uk, kernel@wantstofly.org, tony.luck@intel.com,
       jwboyer@linux.vnet.ibm.com, benh@kernel.crashing.org, paulus@samba.org,
       dmitry.torokhov@gmail.com, netdev@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-serial@vger.kernel.org,
       linux-wireless@vger.kernel.org, bryan.wu@analog.com, adaplas@gmail.com
Subject: Re: [PATCH] Remove pointless casts from void pointers,
Message-ID: <20071026215805.GD32372@xi.wantstofly.org>
References: <9799624f63e093aa915947aea8fb1b8a5df959a1.1193390973.git.jeff@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9799624f63e093aa915947aea8fb1b8a5df959a1.1193390973.git.jeff@garzik.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2007 at 05:40:22AM -0400, Jeff Garzik wrote:

>  arch/arm/mach-pxa/ssp.c                    |    2 +-
>  arch/arm/mach-s3c2410/usb-simtec.c         |    2 +-
>  arch/arm/plat-omap/mailbox.c               |    2 +-

FWIW

Acked-by: Lennert Buytenhek <buytenh@wantstofly.org>
