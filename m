Return-Path: <linux-kernel-owner+w=401wt.eu-S1757713AbYEVUlN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757713AbYEVUlN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 16:41:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760430AbYEVUkl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 16:40:41 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:50629 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757372AbYEVUkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 16:40:40 -0400
Message-ID: <4835DAD8.2090204@keyaccess.nl>
Date: Thu, 22 May 2008 22:43:04 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@perex.cz>,
       ALSA development <alsa-devel@alsa-project.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] HG -> GIT migration
References: <Pine.LNX.4.61.0805201314190.1798@tm8103-a.perex-int.cz>	<200805211430.06653.linux@audioscience.com>	<Pine.LNX.4.61.0805210805080.1798@tm8103-a.perex-int.cz>	<s5hve18vtml.wl%tiwai@suse.de>	<483415E7.5080402@keyaccess.nl>	<s5hfxsbx27f.wl%tiwai@suse.de>	<48341DF5.4090307@keyaccess.nl>	<Pine.LNX.4.61.0805211517290.1798@tm8103-a.perex-int.cz>	<48343465.2030905@keyaccess.nl>	<s5h8wy3wvyv.wl%tiwai@suse.de>	<48343FF4.8090107@keyaccess.nl> <20080522112412.4a8406fd.sfr@canb.auug.org.au>
In-Reply-To: <20080522112412.4a8406fd.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22-05-08 03:24, Stephen Rothwell wrote:

> Linux-next is rebuilt every day based on Linus' current kernel.  I merge
> all the trees I have been told about and fixup minor conflicts (sometimes
> reverting commits, sometimes applying patches).  So everyday, linux-next
> is completely new.  I do not care if the trees I am merging get rebased.

This means you're going to redo all those (same) minor conflict fixups 
each day again, doesn't it? Or do you pass the fixups back to (one of) 
the conflicting trees?

> I have only had a couple of occasions when the merge conflicts were so
> bad that I had to drop a whole tree, but they were fixed up the next day.
> 
> Linux-next has only one downstream - Andrew's mm tree and he bases on a
> particular day's linux-next tree each time he rebuilds mm.  Testers just
> need to take the complete tree (which isn't too bad if you are using git
> since all the linux-next trees share a lot of objects).
> 
> Does that answer your question?

But yes, it does, thanks.

Rene


