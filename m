Return-Path: <linux-kernel-owner+w=401wt.eu-S1756610AbXIFLIQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756610AbXIFLIQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 07:08:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755173AbXIFLH7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 07:07:59 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:45441 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433AbXIFLH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 07:07:58 -0400
Date: Thu, 6 Sep 2007 13:07:57 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Maarten Maathuis <madman2003@gmail.com>, linux-kernel@vger.kernel.org,
       Robert Hancock <hancockr@shaw.ca>, linux-ide@vger.kernel.org
Subject: Re: [sata_nv] timeout waiting for ADMA IDLE, stat=0x440
In-Reply-To: <20070905094845.1d2f84cb.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0709061302370.25942@fbirervta.pbzchgretzou.qr>
References: <fa.JryGluomV43EviuSMJKX+JI+tvU@ifi.uio.no> <46CF68C4.9040506@shaw.ca>
 <6d4bc9fc0708250637g10c75f44x20ae1533874c986a@mail.gmail.com>
 <Pine.LNX.4.64.0708281515340.3018@fbirervta.pbzchgretzou.qr>
 <6d4bc9fc0708280706q278fe285kdf90a27f40d2a55@mail.gmail.com>
 <20070905094845.1d2f84cb.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 5 2007 09:48, Andrew Morton wrote:
>> On 8/28/07, Jan Engelhardt <jengelh@computergmbh.de> wrote:
>> > On Aug 25 2007 15:37, Maarten Maathuis wrote:
>> > >
>> > >A broken cable seems like a realistic possibility, so i swapped it for
>> > >another cable. I will try if that solves the problem.
>> >
>> > Hi, did you have any success/failure, other updates?
>> > I am facing a similar problem (just posted to linux-ide@vger.kernel.org),
>> > but also with 2.6.18, and it does not look like an NCQ or loose cable problem (got a
>> > backplane, and sda is working normal).
>
>This is a rather comedic email thread, with people top-posting, others
>leaving others off the cc list, Robert's MUA reliably and inexplicably
>mangling both In-Reply-To: and References: thus breaking threading, no
>visible sign of how Jan got involved and no linux-ide cc's.

I wrote Maarten a private mail, w/o any mailing lists CCed or BCCed, 
but with References: (just hit reply button and removed CCs) because I 
assumed his problem was really just the cabling in the end, which does 
not apply to me at all.

>Enough time has passed for everyone to forget all about this.  So Maarten,
>if you still believe that this is still a kernel bug then please update us
>on its status and provide a full description for linux-ide..  Please use
>reply-to-all for that.
