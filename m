Return-Path: <linux-kernel-owner+w=401wt.eu-S1759297AbYENB6v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759297AbYENB6v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 21:58:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757286AbYENB6j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 21:58:39 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:35320 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755549AbYENB6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 21:58:38 -0400
Date: Tue, 13 May 2008 18:58:15 -0700
From: Greg KH <greg@kroah.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, netdev@vger.kernel.org,
       Andrew Bird <ajb@spheresystems.co.uk>,
       Javier Marcet <javier@krausbeck.org>, Filip Aben <f.aben@option.com>,
       Paulius Zaleckas <paulius.zaleckas@teltonika.lt>,
       Oliver Neukum <oliver@neukum.org>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HSO: add option hso driver
Message-ID: <20080514015815.GA29785@kroah.com>
References: <20080513215134.GC6139@kroah.com> <20080513232727.21c74bb2@core> <482A23B8.7050705@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <482A23B8.7050705@pobox.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2008 at 07:26:48PM -0400, Jeff Garzik wrote:
> Alan Cox wrote:
>>> Jeff, please queue this up for 2.6.27 if there are no problems that you
>>> can see.  It has been in the linux-next tree for a while, and many users
>>> are reporting that it is working for them.
>>>
>>> Or if you feel it's ok for 2.6.26, I will not object to that either :)
>> Can we get it into 2.6.26 - its a driver for new hardware and the driver
>> is going to get a clean up for 2.6.27 anyway.
>> Comments below are minor and I don't think blockers
>> So for the serial side
>> Acked-by: Alan Cox <alan@redhat.com>

Thanks, I'll provide a clean-up patch based on this review in a few
hours.

Unless Jeff would just like a whole new patch?

> AFAIK new drivers are OK post-rc1, since no possibility of regression and 
> it enables new users.

Thanks, I appreciate it.

greg k-h
