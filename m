Return-Path: <linux-kernel-owner+w=401wt.eu-S1765475AbXF1Sds@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765475AbXF1Sds (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 14:33:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758053AbXF1Sdl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 14:33:41 -0400
Received: from 41-052.adsl.zetnet.co.uk ([194.247.41.52]:54062 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757199AbXF1Sdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 14:33:40 -0400
To: Adrian Bunk <bunk@stusta.de>
Cc: Olivier Galibert <galibert@pobox.com>, Takashi Iwai <tiwai@suse.de>,
       Tomasz K?oczko <kloczek@rudy.mif.pg.gda.pl>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: Is it time for remove (crap) ALSA from kernel tree ?
References: <Pine.BSO.4.63.0706241943190.25800@rudy.mif.pg.gda.pl>
	<20070624200837.16e11305@the-village.bc.nu>
	<Pine.BSO.4.63.0706242113530.25800@rudy.mif.pg.gda.pl>
	<20070624215724.025a5de5@the-village.bc.nu>
	<Pine.BSO.4.63.0706251052380.25800@rudy.mif.pg.gda.pl>
	<s5h3b0gi9mp.wl%tiwai@suse.de>
	<Pine.BSO.4.63.0706251308020.25800@rudy.mif.pg.gda.pl>
	<s5hzm2ogqr7.wl%tiwai@suse.de>
	<20070625124442.GA44019@dspnet.fr.eu.org>
	<20070625132107.GD1094@stusta.de>
From: Nix <nix@esperi.org.uk>
Emacs: an inspiring example of form following function... to Hell.
Date: Thu, 28 Jun 2007 19:30:36 +0100
In-Reply-To: <20070625132107.GD1094@stusta.de> (Adrian Bunk's message of "25 Jun 2007 14:21:10 +0100")
Message-ID: <87tzssextf.fsf@hades.wkstn.nix>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.5-b27 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-DCC-CTc-dcc2-Metrics: hades 1031; Body=6 Fuz1=6 Fuz2=6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 Jun 2007, Adrian Bunk stated:
> If people often run into this problem it might make sense to deprecate 
> the in-kernel OSS emulation and point people to the userspace emulation 
> instead?

So now people need to know internal implementation details like if a
program uses ALSA or OSS interfaces before they know how to *run* it?

That doesn't sound especially nice to use (and before you say
`distributors will do it', not all programs are built by distributors).
