Return-Path: <linux-kernel-owner+w=401wt.eu-S1761997AbYGOVoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761997AbYGOVoX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 17:44:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754168AbYGOVoO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 17:44:14 -0400
Received: from www.tglx.de ([62.245.132.106]:33369 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752382AbYGOVoO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 17:44:14 -0400
Date: Tue, 15 Jul 2008 23:43:21 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [GIT pull] x86 updates
In-Reply-To: <alpine.LFD.1.10.0807151417440.2867@woody.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0807152341240.3283@apollo.tec.linutronix.de>
References: <alpine.LFD.1.10.0807152249270.3283@apollo.tec.linutronix.de> <alpine.LFD.1.10.0807151417440.2867@woody.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jul 2008, Linus Torvalds wrote:
> 
> On Tue, 15 Jul 2008, Thomas Gleixner wrote:
> >
> > Please pull the latest x86/urgent git tree from:
> > 
> >    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86/urgent
> 
> Hmm> "Already up-to-date"?

Strange,

http://git.kernel.org/?p=linux/kernel/git/tip/linux-2.6-tip.git;a=shortlog;h=x86/urgent

has a commit on top of your tree. 

commit	     431ceb83f703a343bdd14350480a2224fa4bfedf
tree	     2f4644aec0d326e23327ed2297a4a4f52b1d830e
parent	     b9d2252c1e44fa83a4e65fdc9eb93db6297c55af

I waited with the pull request until it showed up there.

Thanks,

	tglx
