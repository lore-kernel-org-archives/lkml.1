Return-Path: <linux-kernel-owner+w=401wt.eu-S1758219AbXF0LSx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758219AbXF0LSx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 07:18:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755192AbXF0LSo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 07:18:44 -0400
Received: from animx.eu.org ([216.98.75.249]:42035 "EHLO animx.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755131AbXF0LSn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 07:18:43 -0400
Date: Wed, 27 Jun 2007 07:11:45 -0400
From: Wakko Warner <wakko@animx.eu.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Is it time for remove (crap) ALSA from kernel tree ?
Message-ID: <20070627111145.GA23580@animx.eu.org>
Mail-Followup-To: Takashi Iwai <tiwai@suse.de>,
	linux-kernel@vger.kernel.org
References: <Pine.BSO.4.63.0706241943190.25800@rudy.mif.pg.gda.pl> <s5h4pkwi9u0.wl%tiwai@suse.de> <4680310D.6060206@opensound.com> <20070625231750.GF1094@stusta.de> <20070626162515.GA19677@animx.eu.org> <s5habumfykr.wl%tiwai@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5habumfykr.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.6+20040907i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Takashi Iwai wrote:
> At Tue, 26 Jun 2007 12:25:16 -0400,
> Wakko Warner wrote:
> > I have a motherboard with an intel chipset and onboard audio.  I have a
> > problem with alsa.  There's no pcm* files in /proc/asound/card0.
> 
> Set CONFIG_SND_VERBOSE_PROCFS=y.

GAH!  Thanks, I didn't think I needed it but it is set on the one that
works.

-- 
 Lab tests show that use of micro$oft causes cancer in lab animals
 Got Gas???
