Return-Path: <linux-kernel-owner+w=401wt.eu-S1759435AbZD2HuL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759435AbZD2HuL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 03:50:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758409AbZD2Hqa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 03:46:30 -0400
Received: from cantor.suse.de ([195.135.220.2]:50628 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756442AbZD2Hq3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 03:46:29 -0400
Message-ID: <49F805CC.2080108@suse.de>
Date: Wed, 29 Apr 2009 16:46:20 +0900
From: Tejun Heo <teheo@suse.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: tiwai@suse.de, linux-kernel@vger.kernel.org, greg@kroah.com,
       fuse-devel@lists.sourceforge.net
Subject: Re: [ANNOUNCE] OSS Proxy 1.2 using CUSE
References: <48B6F711.1040604@kernel.org>	<49E3F91E.4000801@suse.de>	<E1Lypk4-0004it-BA@pomaz-ex.szeredi.hu>	<s5hmya0spao.wl%tiwai@suse.de>	<E1Lyqvi-0004vX-2G@pomaz-ex.szeredi.hu> <s5hfxfsr2uq.wl%tiwai@suse.de> <E1Lytf8-0005LD-HJ@pomaz-ex.szeredi.hu> <49F792A5.2070202@suse.de> <E1Lz45o-0006ej-8d@pomaz-ex.szeredi.hu>
In-Reply-To: <E1Lz45o-0006ej-8d@pomaz-ex.szeredi.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi wrote:
> If distros are committed to making PA the default, and ALSA through PA
> doesn't have any major disadvatnages then it sounds like a perfect
> solution to everything.
> 
> The fact that OpenSUSE-11.1 is not there yet just made me think this
> problem is worse than it really is.

SL111 is configured to use PA by default and works just fine (sans
bugs of course).  Even SL110 was fine from configuration POV although
there were more bugs.  I have no idea why ALSA via PA took explicit
configuration on your machine.

Thanks.

-- 
tejun
