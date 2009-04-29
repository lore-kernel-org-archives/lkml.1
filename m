Return-Path: <linux-kernel-owner+w=401wt.eu-S1753831AbZD2HNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831AbZD2HNX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 03:13:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751105AbZD2HNO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 03:13:14 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:44795 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbZD2HNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 03:13:13 -0400
To: tiwai@suse.de
CC: miklos@szeredi.hu, teheo@suse.de, linux-kernel@vger.kernel.org,
       greg@kroah.com, fuse-devel@lists.sourceforge.net
In-reply-to: <s5hskjsihst.wl%tiwai@suse.de> (message from Takashi Iwai on Tue,
	28 Apr 2009 23:34:26 +0200)
Subject: Re: [ANNOUNCE] OSS Proxy 1.2 using CUSE
References: <48B6F711.1040604@kernel.org>
	<49E3F91E.4000801@suse.de>
	<E1Lypk4-0004it-BA@pomaz-ex.szeredi.hu>
	<s5hmya0spao.wl%tiwai@suse.de>
	<E1Lyqvi-0004vX-2G@pomaz-ex.szeredi.hu>
	<s5hfxfsr2uq.wl%tiwai@suse.de>
	<E1Lytf8-0005LD-HJ@pomaz-ex.szeredi.hu> <s5hskjsihst.wl%tiwai@suse.de>
Message-Id: <E1Lz3yg-0006dH-Nl@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 29 Apr 2009 09:13:10 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Apr 2009, Takashi Iwai wrote:
> At Tue, 28 Apr 2009 22:12:18 +0200,
> Miklos Szeredi wrote:
> > ...done.  Well, now things do work, but the sound quality is very
> > crappy when PA is mixing two or more streams together (loud cracking
> > that maybe sounds like integer overflow).
> 
> Or because of older version of PA.  The one in SUSE Factory (or some
> OBS repo), version 0.9.14 or newer, might improve it.

OK, 0.9.14 is much better than 0.9.12.  Thanks for the help.

Miklos
