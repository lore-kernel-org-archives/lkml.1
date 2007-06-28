Return-Path: <linux-kernel-owner+w=401wt.eu-S1765695AbXF1Umt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765695AbXF1Umt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 16:42:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759878AbXF1Umm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 16:42:42 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:43620 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757619AbXF1Umm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 16:42:42 -0400
Date: Thu, 28 Jun 2007 22:43:05 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Lee Revell <rlrevell@joe-job.com>
Cc: Rene Herman <rene.herman@gmail.com>, Nix <nix@esperi.org.uk>,
       Olivier Galibert <galibert@pobox.com>, Takashi Iwai <tiwai@suse.de>,
       Tomasz K?oczko <kloczek@rudy.mif.pg.gda.pl>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: Is it time for remove (crap) ALSA from kernel tree ?
Message-ID: <20070628204305.GB6087@stusta.de>
References: <20070624215724.025a5de5@the-village.bc.nu> <Pine.BSO.4.63.0706251052380.25800@rudy.mif.pg.gda.pl> <s5h3b0gi9mp.wl%tiwai@suse.de> <Pine.BSO.4.63.0706251308020.25800@rudy.mif.pg.gda.pl> <s5hzm2ogqr7.wl%tiwai@suse.de> <20070625124442.GA44019@dspnet.fr.eu.org> <20070625132107.GD1094@stusta.de> <87tzssextf.fsf@hades.wkstn.nix> <468413D2.60101@gmail.com> <75b66ecd0706281320s29178c8brec8c3ef6b7fe7e7b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <75b66ecd0706281320s29178c8brec8c3ef6b7fe7e7b@mail.gmail.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 28, 2007 at 04:20:45PM -0400, Lee Revell wrote:
> On 6/28/07, Rene Herman <rene.herman@gmail.com> wrote:
>> ALSA has been the Linux soundsystem for a number of years now and as such,
>> an application that runs under Linux and produces sound more and more can 
>> be
>> expected to do so using the Linux API. The only reason it _can_ be seen as 
>> a
>> detail is due to the Just Works nature of the OSS emulation but that is
>> changing due to the software mixing. Binary apps are also moving to ALSA
>> currently, ie, flash, skype, ...
>
> If your disto ships with any OSS apps using the in-kernel emulation
> you should file a bug report, as it results in bizarre and undesirable
> behavior - a single app opening /dev/dsp will block audio for every
> other app (OSS or ALSA) on the vast majority of hardware out there.

There's software like mplayer that supports both and tries OSS first...

> Lee

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

