Return-Path: <linux-kernel-owner+w=401wt.eu-S1763580AbXJQGMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763580AbXJQGMU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 02:12:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751870AbXJQGMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 02:12:09 -0400
Received: from mail1.perex.cz ([212.20.107.53]:60500 "EHLO mail1.perex.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751848AbXJQGMI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 02:12:08 -0400
Date: Wed, 17 Oct 2007 08:12:06 +0200 (CEST)
From: Jaroslav Kysela <perex@perex.cz>
X-X-Sender: perex@tm8103.perex-int.cz
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       krzysztof.h1@wp.pl
Subject: Re: suspicious ALSA empty commit
In-Reply-To: <alpine.LFD.0.999.0710161624350.26902@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.61.0710170809580.11118@tm8103.perex-int.cz>
References: <20071016.155044.82377336.davem@davemloft.net>
 <alpine.LFD.0.999.0710161624350.26902@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Oct 2007, Linus Torvalds wrote:

> On Tue, 16 Oct 2007, David Miller wrote:
> > 
> > While scanning over today's updates in Linus's tree, I noticed
> > the following commit has no changes, and this does not appear
> > to be intentional.
> 
> Interesting. You're right, I didn't notice.

I didn't notice, too. I've fixed this commit in my git tree.

Linus, please pull from [the linus branch at]:

  master.kernel.org:/pub/scm/linux/kernel/git/perex/alsa.git linus
gitweb interface:
  http://www.kernel.org/git/?p=linux/kernel/git/perex/alsa.git

					Thanks,
						Jaroslav

-----
Jaroslav Kysela <perex@perex.cz>
Linux Kernel Sound Maintainer
ALSA Project
