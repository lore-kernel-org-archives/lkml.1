Return-Path: <linux-kernel-owner+w=401wt.eu-S935437AbYEUPiV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935437AbYEUPiV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 11:38:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758149AbYEUPiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 11:38:09 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:48996 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754401AbYEUPiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 11:38:08 -0400
Message-ID: <48344271.3090700@keyaccess.nl>
Date: Wed, 21 May 2008 17:40:33 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: alsa-devel@alsa-project.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] HG -> GIT migration
References: <Pine.LNX.4.61.0805201314190.1798@tm8103-a.perex-int.cz>	<200805211430.06653.linux@audioscience.com>	<Pine.LNX.4.61.0805210805080.1798@tm8103-a.perex-int.cz>	<s5hve18vtml.wl%tiwai@suse.de>	<483415E7.5080402@keyaccess.nl>	<s5hfxsbx27f.wl%tiwai@suse.de>	<48341DF5.4090307@keyaccess.nl> <s5habijww7r.wl%tiwai@suse.de>
In-Reply-To: <s5habijww7r.wl%tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21-05-08 16:47, Takashi Iwai wrote:

> Theoretically we can work only using merges.  However, the resultant
> tree will look too complex with lots of merge points at the time of
> the next merge window.  This is also a nightmare for bisecting.  Thus,
> most subsystem trees do rebase before the merge window in practice,
> AFAIK.
> 
> It'd be appreciated if someone can tell me any good workflow to keep a
> good-shaped tree without rebasing...

Over here:

http://lkml.org/lkml/2008/5/17/203

Linus suggests to just not do many merges from upstream -- basically 
only at releases.

I'm only looking at and experiencing things from the limited viewpoint 
of a leaf node though so I'll shut up for a bit first now as this might 
not be helpful.

Rene.
