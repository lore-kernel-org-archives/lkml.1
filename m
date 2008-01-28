Return-Path: <linux-kernel-owner+w=401wt.eu-S1758003AbYA1K37@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758003AbYA1K37 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 05:29:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752162AbYA1K3u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 05:29:50 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:58131 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750878AbYA1K3u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 05:29:50 -0500
Date: Mon, 28 Jan 2008 11:29:45 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: "Francis Moreau" <francis.moro@gmail.com>
Cc: "Jiri Slaby" <jirislaby@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Question about DMA
Message-ID: <20080128112945.401d8a45@dhcp-252-066.norway.atmel.com>
In-Reply-To: <38b2ab8a0801280222m3aadc1b1t792165174733b04d@mail.gmail.com>
References: <38b2ab8a0801271251v1a9ea256w8fa4b9fcc620f742@mail.gmail.com>
	<479D06E0.3090601@gmail.com>
	<38b2ab8a0801280055j6d1d235boe79e6aea058f8f96@mail.gmail.com>
	<20080128102149.545c0619@dhcp-252-066.norway.atmel.com>
	<38b2ab8a0801280222m3aadc1b1t792165174733b04d@mail.gmail.com>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jan 2008 11:22:49 +0100
"Francis Moreau" <francis.moro@gmail.com> wrote:

> > Please let me know if you think this will work for your hardware.  
> 
> Thanks for pointing this out. I currently can't look at this but I'll
> try to give it
> a deep look this week.

Great. I'll Cc you on the next round of patches.

> > What platform are you working on, btw?
> >  
> 
> SH

Nice. That means we have potential users on three different
architectures (the other two being avr32 and arm; I wouldn't be too
surprised if powerpc and mips want a piece of the fun at some point
too.)

Haavard
