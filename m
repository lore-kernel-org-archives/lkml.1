Return-Path: <linux-kernel-owner+w=401wt.eu-S1760502AbYEMX1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760502AbYEMX1R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 19:27:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756812AbYEMX05
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 19:26:57 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:49223 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756654AbYEMX0z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 19:26:55 -0400
Message-ID: <482A23B8.7050705@pobox.com>
Date: Tue, 13 May 2008 19:26:48 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Greg KH <greg@kroah.com>, netdev@vger.kernel.org,
       Andrew Bird <ajb@spheresystems.co.uk>,
       Javier Marcet <javier@krausbeck.org>, Filip Aben <f.aben@option.com>,
       Paulius Zaleckas <paulius.zaleckas@teltonika.lt>,
       Oliver Neukum <oliver@neukum.org>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HSO: add option hso driver
References: <20080513215134.GC6139@kroah.com> <20080513232727.21c74bb2@core>
In-Reply-To: <20080513232727.21c74bb2@core>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> Jeff, please queue this up for 2.6.27 if there are no problems that you
>> can see.  It has been in the linux-next tree for a while, and many users
>> are reporting that it is working for them.
>>
>> Or if you feel it's ok for 2.6.26, I will not object to that either :)
> 
> Can we get it into 2.6.26 - its a driver for new hardware and the driver
> is going to get a clean up for 2.6.27 anyway.
> 
> Comments below are minor and I don't think blockers
> 
> So for the serial side
> 
> Acked-by: Alan Cox <alan@redhat.com>

AFAIK new drivers are OK post-rc1, since no possibility of regression 
and it enables new users.

However, an exception to that might be a super-huge driver slipped in at 
the last minute with no review (clearly not the case here)

	Jeff



