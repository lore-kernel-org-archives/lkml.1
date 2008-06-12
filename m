Return-Path: <linux-kernel-owner+w=401wt.eu-S1756314AbYFLCvo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756314AbYFLCvo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 22:51:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755902AbYFLCvT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 22:51:19 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:40523 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755846AbYFLCvP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 22:51:15 -0400
Message-ID: <48508F15.4020001@pobox.com>
Date: Wed, 11 Jun 2008 22:51:01 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@suse.de>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, netdev@vger.kernel.org,
       Andrew Bird <ajb@spheresystems.co.uk>,
       Javier Marcet <javier@krausbeck.org>, Filip Aben <f.aben@option.com>,
       Paulius Zaleckas <paulius.zaleckas@teltonika.lt>,
       Oliver Neukum <oliver@neukum.org>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: HSO: add option hso driver
References: <20080513215134.GC6139@kroah.com> <20080513232727.21c74bb2@core> <482A23B8.7050705@pobox.com> <20080514015815.GA29785@kroah.com> <20080514045712.GA2843@kroah.com>
In-Reply-To: <20080514045712.GA2843@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg Kroah-Hartman wrote:
> This driver is for a number of different Option devices.  Originally
> written by Option and Andrew Bird, but cleaned up massivly for
> acceptance into mainline by me and others.
> 
> Many thanks to the following for their help in cleaning up the driver by
> providing feedback and patches to it:
> 	- Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
> 	- Oliver Neukum <oliver@neukum.org>
> 	- Alan Cox <alan@lxorguk.ukuu.org.uk>
> 	- Javier Marcet <javier@krausbeck.org>
> 
> 
> Cc: Andrew Bird <ajb@spheresystems.co.uk>
> Cc: Javier Marcet <javier@krausbeck.org>
> Cc: Filip Aben <f.aben@option.com>
> Cc: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
> Cc: Oliver Neukum <oliver@neukum.org>
> Acked-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> 
> ---
> 
> Jeff, this is an updated version from what I previously sent.  I have no
> objection for this to go into 2.6.26.
> 
>  drivers/net/Makefile     |    1 
>  drivers/net/usb/Kconfig  |   10 
>  drivers/net/usb/Makefile |    1 
>  drivers/net/usb/hso.c    | 2836 +++++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 2848 insertions(+)

applied



