Return-Path: <linux-kernel-owner+w=401wt.eu-S1754097AbXKJSBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097AbXKJSBf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 13:01:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753152AbXKJSBS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 13:01:18 -0500
Received: from rtr.ca ([76.10.145.34]:4203 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752856AbXKJSBR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 13:01:17 -0500
Message-ID: <4735F1E8.1070009@rtr.ca>
Date: Sat, 10 Nov 2007 13:01:12 -0500
From: Mark Lord <liml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Matthias Schniedermeyer <ms@citd.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jeff Garzik <jeff@garzik.org>,
       Riki Oktarianto <rkoktarianto@gmail.com>, linux-kernel@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-ide@vger.kernel.org
Subject: Re: [PATCH] Add quirk to set AHCI mode on ICH boards
References: <20071109020235.GA2031@ceren> <20071109023129.GA25581@havoc.gtf.org> <4733D421.7000505@rtr.ca> <20071109034622.GB25581@havoc.gtf.org> <20071109120425.543971bf@the-village.bc.nu> <20071109233215.GA22498@citd.de>
In-Reply-To: <20071109233215.GA22498@citd.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matthias Schniedermeyer wrote:
>..
> My computer/mainboard @work has such a "broken" BIOS. Of the 5 
> SATA-Ports this MB has only 1 (and 1 "missing" that is reported by linux 
> but i can't find on the MB) is configured as AHCI which means that with 
..

I have a P5B-VM here (very similar).
The "missing" AHCI port is an eSATA connector on the back panel
for this board.  Maybe your board just has empty tracks where
the connector would otherwise have been populated (?).
