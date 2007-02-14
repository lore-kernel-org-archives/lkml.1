Return-Path: <linux-kernel-owner+w=401wt.eu-S932289AbXBNRyI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932289AbXBNRyI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 12:54:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932398AbXBNRyI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 12:54:08 -0500
Received: from smtp.osdl.org ([65.172.181.24]:37096 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932289AbXBNRyH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 12:54:07 -0500
Date: Wed, 14 Feb 2007 09:53:57 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jaroslav Kysela <perex@suse.cz>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Takashi Iwai <tiwai@suse.de>
Subject: Re: [ALSA PATCH] alsa-git merge request
In-Reply-To: <Pine.LNX.4.61.0702140844300.7697@tm8103.perex-int.cz>
Message-ID: <Pine.LNX.4.64.0702140950400.3604@woody.linux-foundation.org>
References: <Pine.LNX.4.61.0702140844300.7697@tm8103.perex-int.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 14 Feb 2007, Jaroslav Kysela wrote:
>
> Linus, please do an update from:
> 
>   http://www.kernel.org/pub/scm/linux/kernel/git/perex/alsa.git
>   (linus branch)

Please fix your script.

Not only is the http:// protocol terminally broken (use git:// or 
master.kernel.org instead), your "(linus branch)" thing is on the wrong 
line and hard to see.

It's supposed to be something like

 "Please pull from [the linus branch at]

    master.kernel.org:/pub/scm/linux/kernel/git/perex/alsa.git linus

so that I don't even by mistake miss the branch-name (because it's on the 
same line). And http:// for git really is so broken (slow, unsafe) that 
you should never use it if you have any choice at all.

Pulled.

		Linus
