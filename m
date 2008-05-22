Return-Path: <linux-kernel-owner+w=401wt.eu-S1752072AbYEVOZJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752072AbYEVOZJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 10:25:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751468AbYEVOY4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 10:24:56 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:49323 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751479AbYEVOY4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 10:24:56 -0400
Date: Thu, 22 May 2008 17:22:36 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: Rene Herman <rene.herman@keyaccess.nl>, Jeff Garzik <jeff@garzik.org>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       alsa-devel@alsa-project.org, perex@perex.cz
Subject: Re: Moving sound/* to drivers/ ?
Message-ID: <20080522142236.GA27301@cs181133002.pp.htv.fi>
References: <s5hzlqjz74d.wl%tiwai@suse.de> <4834B252.1080700@garzik.org> <4834B5E2.3040301@keyaccess.nl> <s5hy7623fqs.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <s5hy7623fqs.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2008 at 10:27:55AM +0200, Takashi Iwai wrote:
> At Thu, 22 May 2008 01:53:06 +0200,
> Rene Herman wrote:
>...
> An argument for keeping the sound core in /sound is that this is used
> not only by sound drivers but also by some video drivers.

Same goes for e.g. some of the USB or PCI code.

We could start splitting stuff like crazy, but what would we really 
gain by doing it?

> Takashi

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

