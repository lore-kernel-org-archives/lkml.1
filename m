Return-Path: <linux-kernel-owner+w=401wt.eu-S1759283AbYDXNQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759283AbYDXNQe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 09:16:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753190AbYDXNQ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 09:16:28 -0400
Received: from mail1.perex.cz ([212.20.107.53]:35154 "EHLO mail1.perex.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753182AbYDXNQ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 09:16:27 -0400
Date: Thu, 24 Apr 2008 15:16:24 +0200 (CEST)
From: Jaroslav Kysela <perex@perex.cz>
X-X-Sender: perex@tm8103.perex-int.cz
To: Takashi Iwai <tiwai@suse.de>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] ALSA updates for 2.6.26
In-Reply-To: <s5hwsmnbhlv.wl%tiwai@suse.de>
Message-ID: <Pine.LNX.4.61.0804241514210.7882@tm8103.perex-int.cz>
References: <s5hwsmnbhlv.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Apr 2008, Takashi Iwai wrote:

> Linus,
> 
> please pull ALSA updates for 2.6.26 from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound-2.6.git for-linus
> 
> 
> This updates include a few new drivers (pcsp, aw2, soc davinci, etc),
> and many fixes/updates for HD-audio and oxygen drivers, together with
> lots of trivial fixes.

A repository with identical patches and ALSA version update is here:

  master.kernel.org:/pub/scm/linux/kernel/git/perex/alsa.git linus
gitweb interface:
  http://www.kernel.org/git/?p=linux/kernel/git/perex/alsa.git

The GNU patch is available at:

  ftp://ftp.alsa-project.org/pub/kernel-patches/alsa-git-2008-04-24.patch.gz

						Jaroslav

-----
Jaroslav Kysela <perex@perex.cz>
Linux Kernel Sound Maintainer
ALSA Project, Red Hat, Inc.

