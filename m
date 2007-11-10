Return-Path: <linux-kernel-owner+w=401wt.eu-S1763526AbXKJDIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763526AbXKJDIW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 22:08:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754431AbXKJDIN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 22:08:13 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:49248 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752392AbXKJDIM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 22:08:12 -0500
Message-ID: <47352095.4010502@garzik.org>
Date: Fri, 09 Nov 2007 22:08:05 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Matthias Schniedermeyer <ms@citd.de>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Mark Lord <liml@rtr.ca>,
       Riki Oktarianto <rkoktarianto@gmail.com>, linux-kernel@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-ide@vger.kernel.org
Subject: Re: [PATCH] Add quirk to set AHCI mode on ICH boards
References: <20071109020235.GA2031@ceren> <20071109023129.GA25581@havoc.gtf.org> <4733D421.7000505@rtr.ca> <20071109034622.GB25581@havoc.gtf.org> <20071109120425.543971bf@the-village.bc.nu> <20071109233215.GA22498@citd.de>
In-Reply-To: <20071109233215.GA22498@citd.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matthias Schniedermeyer wrote:
> And on the topic of "broken" BIOSes. I have a little empathy for the MB 
> manufactures as non-RAID AHCI royaly screws Windos, so not supporting it 
> reduces their support costs enough to overlook screwing the non-windos 
> faction.

non-RAID AHCI works just fine on Windows.

	Jeff


