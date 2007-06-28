Return-Path: <linux-kernel-owner+w=401wt.eu-S932100AbXF1Vlr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932100AbXF1Vlr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 17:41:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763655AbXF1Vlk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 17:41:40 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:54416 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763574AbXF1Vlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 17:41:39 -0400
Message-ID: <46842A2D.4060201@gmail.com>
Date: Thu, 28 Jun 2007 23:37:49 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Nix <nix@esperi.org.uk>, Olivier Galibert <galibert@pobox.com>,
       Takashi Iwai <tiwai@suse.de>,
       Tomasz K?oczko <kloczek@rudy.mif.pg.gda.pl>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: Is it time for remove (crap) ALSA from kernel tree ?
References: <20070624200837.16e11305@the-village.bc.nu> <Pine.BSO.4.63.0706242113530.25800@rudy.mif.pg.gda.pl> <20070624215724.025a5de5@the-village.bc.nu> <Pine.BSO.4.63.0706251052380.25800@rudy.mif.pg.gda.pl> <s5h3b0gi9mp.wl%tiwai@suse.de> <Pine.BSO.4.63.0706251308020.25800@rudy.mif.pg.gda.pl> <s5hzm2ogqr7.wl%tiwai@suse.de> <20070625124442.GA44019@dspnet.fr.eu.org> <20070625132107.GD1094@stusta.de> <87tzssextf.fsf@hades.wkstn.nix> <20070628210614.GC6087@stusta.de>
In-Reply-To: <20070628210614.GC6087@stusta.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2007 11:06 PM, Adrian Bunk wrote:

> The interesting point is that what you call "internal implementation 
> details" is much _more_ exposed with the OSS emulation in the kernel 
> _enabled_.
> 
> Why?
> 
> Linux software not supporting ALSA has becoming quite esoteric.
> 
> But software like mplayer supporting both and trying OSS first and 
> software supporting both and letting the user choose is today much more 
> common. And that's exactly the case where users run into the results of 
> the "internal implementation detail" that their application used the 
> in-kernel OSS emulation instead of ALSA resulting in exactly these 
> problems.
> 
> There is also a userspace OSS emulation for ALSA not suffering from these
> problems.
> 
> It's not my decision whether or not to remove the in-kernel OSS
> emulation, all I'm saying is that removing it might actually result in
> less users having problems.

For what it's worth -- I do agree with this...

Rene.

