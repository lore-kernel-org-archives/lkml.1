Return-Path: <linux-kernel-owner+w=401wt.eu-S1759319AbXEaWfh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759319AbXEaWfh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 18:35:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753460AbXEaWf3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 18:35:29 -0400
Received: from rtr.ca ([64.26.128.89]:3593 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753119AbXEaWf2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 18:35:28 -0400
Message-ID: <465F4DAC.7080101@rtr.ca>
Date: Thu, 31 May 2007 18:35:24 -0400
From: Mark Lord <liml@rtr.ca>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Daniel J Blueman <daniel.blueman@gmail.com>
Cc: bzolnier@gmail.com, linux-ide@vger.kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Jeff Garzik <jeff@garzik.org>
Subject: Re: Compact Flash performance...
References: <6278d2220705301510y2d81f69eu38fb778d32de05e1@mail.gmail.com>	 <465E3FF0.9010709@rtr.ca>	 <6278d2220705310222rde9ad28ndfd8feced84a3c6f@mail.gmail.com>	 <465EBE20.6090803@rtr.ca>	 <6278d2220705311025q6ee030e2kd44b7302a50ac902@mail.gmail.com>	 <465F360D.6020603@rtr.ca> <6278d2220705311439x40f7b1c1l7cef54acd2e8fcea@mail.gmail.com> <465F4D4E.6050305@rtr.ca>
In-Reply-To: <465F4D4E.6050305@rtr.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Daniel J Blueman wrote:
>>
>> hdparm in the other identify mode does list the UDMA3/4 modes twice
>> [1], which looks odd.

That got fixed a few revisions ago.  Update your copy of hdparm
from the masters on sourceforge.

Cheers
