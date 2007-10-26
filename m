Return-Path: <linux-kernel-owner+w=401wt.eu-S1754855AbXJZM36@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855AbXJZM36 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 08:29:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750823AbXJZM3q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 08:29:46 -0400
Received: from ra.tuxdriver.com ([70.61.120.52]:4726 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750955AbXJZM3o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 08:29:44 -0400
Date: Fri, 26 Oct 2007 08:24:47 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: LKML <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       rmk@arm.linux.org.uk, kernel@wantstofly.org, tony.luck@intel.com,
       jwboyer@linux.vnet.ibm.com, benh@kernel.crashing.org, paulus@samba.org,
       dmitry.torokhov@gmail.com, netdev@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-serial@vger.kernel.org,
       linux-wireless@vger.kernel.org, bryan.wu@analog.com, adaplas@gmail.com
Subject: Re: [PATCH] Remove pointless casts from void pointers,
Message-ID: <20071026122447.GA23415@tuxdriver.com>
References: <9799624f63e093aa915947aea8fb1b8a5df959a1.1193390973.git.jeff@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9799624f63e093aa915947aea8fb1b8a5df959a1.1193390973.git.jeff@garzik.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2007 at 05:40:22AM -0400, Jeff Garzik wrote:
> mostly in and around irq handlers.
> 
> Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
> ---

>  drivers/net/wireless/airo.c                |    5 +++--
>  drivers/net/wireless/hostap/hostap_hw.c    |    2 +-
>  drivers/net/wireless/libertas/if_cs.c      |    2 +-

ACK

-- 
John W. Linville
linville@tuxdriver.com
