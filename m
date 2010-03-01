Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752455Ab0CAPSI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 10:18:08 -0500
Received: from bhuna.collabora.co.uk ([93.93.128.226]:49846 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695Ab0CAPR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 10:17:59 -0500
Date: Mon, 1 Mar 2010 10:17:21 -0500
From: Andres Salomon <dilinger@collabora.co.uk>
To: Ben Gardner <gardner.ben@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] OLPC: ALSA: fix cs5535audio's MIC GPIO to enable input
Message-ID: <20100301101721.6cd30f9b@droptest.queued.net>
In-Reply-To: <808c8e9d1003010655m4f31f3c2wcbe0c1c882ab202e@mail.gmail.com>
References: <808c8e9d1002231455q379b26acq4b4a50188c5d73be@mail.gmail.com>
	<20100224184505.1d8d3380@droptest.queued.net>
	<808c8e9d1002260947k281782al889db51e20073648@mail.gmail.com>
	<20100226160716.1bd4e342@droptest.queued.net>
	<808c8e9d1002261532v447d62dfna61d0b19493b6551@mail.gmail.com>
	<808c8e9d1003010655m4f31f3c2wcbe0c1c882ab202e@mail.gmail.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Mar 2010 08:55:44 -0600
Ben Gardner <gardner.ben@gmail.com> wrote:

> > Lets see how the proposed changes I just sent off are received and go
> > from there.
> 
> Based on the feedback from the other gpio patches, I'd like to do the following:
> 1) drop this patch (olpc-alsa-fix-cs5535audios-mic-gpio-to-enable-input.patch)
> 2) drop the patch that caused this patch to be created
> (cs5535_gpio-gpio_chipget-should-return-the-input-value.patch)
> 3) submit a new patch that contains the original change + the changes
> needed to adjust input/output settings to follow the spirit of
> gpiolib.
> 
> That way, there is one patch that fully fixes the issue and no window
> where the OLPC MIC stuff is broken.
> 

That'd be great, thanks!
