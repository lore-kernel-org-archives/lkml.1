Return-Path: <linux-kernel-owner+w=401wt.eu-S1754919AbXIDPEp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919AbXIDPEp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 11:04:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754123AbXIDPEh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 11:04:37 -0400
Received: from renko.ucs.ed.ac.uk ([129.215.13.3]:57877 "EHLO
	renko.ucs.ed.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754205AbXIDPEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 11:04:37 -0400
From: Alistair John Strachan <alistair@devzero.co.uk>
To: "Abhijit Bhopatkar" <bain@devslashzero.com>
Subject: Re: [PATCH] [ALSA] Added new pin config for first gen macbook.
Date: Tue, 4 Sep 2007 16:00:19 +0100
User-Agent: KMail/1.9.7
Cc: "Takashi Iwai" <tiwai@suse.de>, "Ivan N. Zlatev" <contact@i-nz.net>,
       "Jaroslav Kysela" <perex@suse.cz>, linux-kernel@vger.kernel.org
References: <2ff216280709030325r626d98b3h2c5a48e90470610b@mail.gmail.com> <s5hmyw28u8a.wl%tiwai@suse.de> <2ff216280709040718y4b8e1fa7x1f51cc68f1d18de9@mail.gmail.com>
In-Reply-To: <2ff216280709040718y4b8e1fa7x1f51cc68f1d18de9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709041600.19498.alistair@devzero.co.uk>
X-Edinburgh-Scanned: at renko.ucs.ed.ac.uk
    with MIMEDefang 2.52, Sophie, Sophos Anti-Virus, Clam AntiVirus
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 September 2007 15:18:23 Abhijit Bhopatkar wrote:
[snip]
> > Anyway, it'd be helpful if someone else can check the same MacBook
> > (1st generation, not Pro?) whether the problem is reproducible.
>
> To be precise its Macbook 1st Generation non pro.  with subsystem id
> 0x106b0a00
>
> Well a friend of mine has the same model and i tried things out on his
> machine. to my surprise :(, the original 2.6.23-rc5 is working fine on his
> machine.
>
> So on my machine we booted to windows and tested things out. The sound
> on my machine doesn't work in windows either, although its working in
> OSX.
>
> So sorry for all the noise its most likely a hardware problem after all.
> Although i am baffled as to why old pin config works on this
> particular broken hardware.
>
> I hope i didn't bug you too much, i appreciate your quick responses.

I think the first generation macbook firmwares weren't completely other-OS 
ready when they were shipped (no bootcamp in firmware, iirc). Have you 
applied all available firmware updates? Do you use bootcamp?

-- 
Cheers,
Alistair.

137/1 Warrender Park Road, Edinburgh, UK.
