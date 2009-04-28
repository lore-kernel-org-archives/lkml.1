Return-Path: <linux-kernel-owner+w=401wt.eu-S1762139AbZD1RRa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762139AbZD1RRa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 13:17:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758077AbZD1RRS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 13:17:18 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:40823 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755980AbZD1RRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 13:17:17 -0400
To: tiwai@suse.de
CC: miklos@szeredi.hu, teheo@suse.de, linux-kernel@vger.kernel.org,
       greg@kroah.com, fuse-devel@lists.sourceforge.net
In-reply-to: <s5hmya0spao.wl%tiwai@suse.de> (message from Takashi Iwai on Tue,
	28 Apr 2009 18:42:23 +0200)
Subject: Re: [ANNOUNCE] OSS Proxy 1.2 using CUSE
References: <48B6F711.1040604@kernel.org>
	<49E3F91E.4000801@suse.de>
	<E1Lypk4-0004it-BA@pomaz-ex.szeredi.hu> <s5hmya0spao.wl%tiwai@suse.de>
Message-Id: <E1Lyqvi-0004vX-2G@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 28 Apr 2009 19:17:14 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Apr 2009, Takashi Iwai wrote:
> > In fact if something else is playing though ALSA and I start a
> > playback through ossp, then ossp will print some errors, return EIO
> > and get into a bad state, that it recoveres from only by starting the
> > playback twice more (after stopping the other playback through ALSA).
> 
> Are you using pulse plugin for ALSA, too?

alsa-plugins-pulse package is installed.  How can I find out if ALSA
is actually using this plugin?

What is the disadvantage of non-native ALSA vs. native ALSA?

Thanks,
Miklos
