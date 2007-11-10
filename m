Return-Path: <linux-kernel-owner+w=401wt.eu-S1753711AbXKJL0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753711AbXKJL0b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 06:26:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751717AbXKJL0U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 06:26:20 -0500
Received: from enyo.dsw2k3.info ([195.71.86.239]:36473 "EHLO enyo.dsw2k3.info"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751703AbXKJL0T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 06:26:19 -0500
Date: Sat, 10 Nov 2007 12:26:07 +0100
From: Matthias Schniedermeyer <ms@citd.de>
To: Jeff Garzik <jeff@garzik.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Mark Lord <liml@rtr.ca>,
       Riki Oktarianto <rkoktarianto@gmail.com>, linux-kernel@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-ide@vger.kernel.org
Subject: Re: [PATCH] Add quirk to set AHCI mode on ICH boards
Message-ID: <20071110112607.GA25971@citd.de>
References: <20071109020235.GA2031@ceren> <20071109023129.GA25581@havoc.gtf.org> <4733D421.7000505@rtr.ca> <20071109034622.GB25581@havoc.gtf.org> <20071109120425.543971bf@the-village.bc.nu> <20071109233215.GA22498@citd.de> <47352095.4010502@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47352095.4010502@garzik.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09.11.2007 22:08, Jeff Garzik wrote:
> Matthias Schniedermeyer wrote:
>> And on the topic of "broken" BIOSes. I have a little empathy for the MB 
>> manufactures as non-RAID AHCI royaly screws Windos, so not supporting it 
>> reduces their support costs enough to overlook screwing the non-windos 
>> faction.
>
> non-RAID AHCI works just fine on Windows.

And even if, that doesn't change the fact that there are BIOSes where 
you can't set AHCI-mode, like my MB @work.




Bis denn

-- 
Real Programmers consider "what you see is what you get" to be just as 
bad a concept in Text Editors as it is in women. No, the Real Programmer
wants a "you asked for it, you got it" text editor -- complicated, 
cryptic, powerful, unforgiving, dangerous.

