Return-Path: <linux-kernel-owner+w=401wt.eu-S1755274AbZD2HUp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274AbZD2HUp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 03:20:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751713AbZD2HUg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 03:20:36 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:53492 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887AbZD2HUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 03:20:36 -0400
To: teheo@suse.de
CC: miklos@szeredi.hu, tiwai@suse.de, linux-kernel@vger.kernel.org,
       greg@kroah.com, fuse-devel@lists.sourceforge.net
In-reply-to: <49F792A5.2070202@suse.de> (message from Tejun Heo on Wed, 29 Apr
	2009 08:35:01 +0900)
Subject: Re: [ANNOUNCE] OSS Proxy 1.2 using CUSE
References: <48B6F711.1040604@kernel.org>	<49E3F91E.4000801@suse.de>	<E1Lypk4-0004it-BA@pomaz-ex.szeredi.hu>	<s5hmya0spao.wl%tiwai@suse.de>	<E1Lyqvi-0004vX-2G@pomaz-ex.szeredi.hu> <s5hfxfsr2uq.wl%tiwai@suse.de> <E1Lytf8-0005LD-HJ@pomaz-ex.szeredi.hu> <49F792A5.2070202@suse.de>
Message-Id: <E1Lz45o-0006ej-8d@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 29 Apr 2009 09:20:32 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Apr 2009, Tejun Heo wrote:
> On default installation of any recent major distros, PA is the default
> and ALSA via PA is the default too, so the configuration doesn't
> matter at all.  I think PA is the way to go (all other guys are
> already there) && we're past the point of no return at this point &&
> it's nicer to program to and has some features I wanted (per-pgrp
> volume for example), so...

If distros are committed to making PA the default, and ALSA through PA
doesn't have any major disadvatnages then it sounds like a perfect
solution to everything.

The fact that OpenSUSE-11.1 is not there yet just made me think this
problem is worse than it really is.

Thanks,
Miklos
