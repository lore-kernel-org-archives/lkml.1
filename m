Return-Path: <linux-kernel-owner+w=401wt.eu-S1755537AbYFSXe5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537AbYFSXe5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 19:34:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754135AbYFSXer
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 19:34:47 -0400
Received: from mga11.intel.com ([192.55.52.93]:13547 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754109AbYFSXer (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 19:34:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,675,1204531200"; 
   d="scan'208";a="579888916"
Date: Thu, 19 Jun 2008 16:34:46 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Simon Holm =?iso-8859-1?Q?Th=F8gersen?= <odie@cs.aau.dk>
Cc: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Patrick McHardy <kaber@trash.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [git pull] x86 fixes
Message-ID: <20080619233446.GG23370@linux-os.sc.intel.com>
References: <20080619151333.GA8952@elte.hu> <1213910986.21443.42.camel@odie.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1213910986.21443.42.camel@odie.local>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2008 at 02:29:46PM -0700, Simon Holm Thøgersen wrote:
> tor, 19 06 2008 kl. 17:13 +0200, skrev Ingo Molnar:
> > Linus,
> >
> > please pull the latest x86 fixes git tree from:
> >
> >    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus
> >
> 
> > Suresh Siddha (1):
> >       x86: fix NULL pointer deref in __switch_to
> 
> Ingo, Rusty and Suresh
> 
> This doesn't contain the lguest part of the fix that Patrick and I
> reported were necessary to fix the problem we reported. Is this being
> pushed via another path?

Simon, Yes. Ingo is going to push the missing pieces with another patch.

thanks,
suresh
