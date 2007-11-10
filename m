Return-Path: <linux-kernel-owner+w=401wt.eu-S1753522AbXKJSi2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522AbXKJSi2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 13:38:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751633AbXKJSiT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 13:38:19 -0500
Received: from enyo.dsw2k3.info ([195.71.86.239]:51428 "EHLO enyo.dsw2k3.info"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751605AbXKJSiS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 13:38:18 -0500
Date: Sat, 10 Nov 2007 19:38:05 +0100
From: Matthias Schniedermeyer <ms@citd.de>
To: Mark Lord <liml@rtr.ca>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jeff Garzik <jeff@garzik.org>,
       Riki Oktarianto <rkoktarianto@gmail.com>, linux-kernel@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-ide@vger.kernel.org
Subject: Re: [PATCH] Add quirk to set AHCI mode on ICH boards
Message-ID: <20071110183805.GA28230@citd.de>
References: <20071109020235.GA2031@ceren> <20071109023129.GA25581@havoc.gtf.org> <4733D421.7000505@rtr.ca> <20071109034622.GB25581@havoc.gtf.org> <20071109120425.543971bf@the-village.bc.nu> <20071109233215.GA22498@citd.de> <4735F1E8.1070009@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4735F1E8.1070009@rtr.ca>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10.11.2007 13:01, Mark Lord wrote:
> Matthias Schniedermeyer wrote:
>> ..
>> My computer/mainboard @work has such a "broken" BIOS. Of the 5 SATA-Ports 
>> this MB has only 1 (and 1 "missing" that is reported by linux but i can't 
>> find on the MB) is configured as AHCI which means that with 
> ..
>
> I have a P5B-VM here (very similar).
> The "missing" AHCI port is an eSATA connector on the back panel
> for this board.  Maybe your board just has empty tracks where
> the connector would otherwise have been populated (?).

Maybe, but that still doesn't "solve" my problem of the SATA-ports that 
i have to drive by PIIX, instead of the more preferable AHCI.




Bis denn

-- 
Real Programmers consider "what you see is what you get" to be just as 
bad a concept in Text Editors as it is in women. No, the Real Programmer
wants a "you asked for it, you got it" text editor -- complicated, 
cryptic, powerful, unforgiving, dangerous.

