Return-Path: <linux-kernel-owner+w=401wt.eu-S1759810AbXEaWhe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759810AbXEaWhe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 18:37:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753777AbXEaWh0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 18:37:26 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:47668 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753304AbXEaWhZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 18:37:25 -0400
Message-ID: <465F4E20.5080503@garzik.org>
Date: Thu, 31 May 2007 18:37:20 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Mark Lord <liml@rtr.ca>
CC: Daniel J Blueman <daniel.blueman@gmail.com>, bzolnier@gmail.com,
       linux-ide@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Compact Flash performance...
References: <6278d2220705301510y2d81f69eu38fb778d32de05e1@mail.gmail.com>	 <465E3FF0.9010709@rtr.ca>	 <6278d2220705310222rde9ad28ndfd8feced84a3c6f@mail.gmail.com>	 <465EBE20.6090803@rtr.ca>	 <6278d2220705311025q6ee030e2kd44b7302a50ac902@mail.gmail.com>	 <465F360D.6020603@rtr.ca> <6278d2220705311439x40f7b1c1l7cef54acd2e8fcea@mail.gmail.com> <465F4D4E.6050305@rtr.ca>
In-Reply-To: <465F4D4E.6050305@rtr.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Some cards may perform better when their "memory" interface is used
> instead of the "I/O" interface, or vice-versa.  I'm not sure which
> of the two methods was selected by libata (probably the "memory" 
> interface).

I am very CF-ignorant.  How does libata select a memory or I/O interface 
on a CF device?

	Jeff


