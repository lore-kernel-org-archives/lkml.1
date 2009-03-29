Return-Path: <linux-kernel-owner+w=401wt.eu-S1757606AbZC2Ojg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757606AbZC2Ojg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 10:39:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754404AbZC2Oj1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 10:39:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:38255 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753016AbZC2Oj0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 10:39:26 -0400
Subject: Re: [git-pull -tip] x86: include inverse Xmas tree patches
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, Hugh Dickins <hugh@veritas.com>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0903291345300.3397@localhost.localdomain>
References: <1238251730.2526.2.camel@ht.satnam>
	 <Pine.LNX.4.64.0903281508410.21235@blonde.anvils>
	 <20090328234012.GC4957@elte.hu> <1238308734.3074.3.camel@ht.satnam>
	 <alpine.LFD.2.00.0903291345300.3397@localhost.localdomain>
Content-Type: text/plain
Date: Sun, 29 Mar 2009 20:08:50 +0530
Message-Id: <1238337530.2534.3.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-03-29 at 13:46 +0200, Thomas Gleixner wrote:
> On Sun, 29 Mar 2009, Jaswinder Singh Rajput wrote:
> > On Sun, 2009-03-29 at 00:40 +0100, Ingo Molnar wrote:
> > > * Hugh Dickins <hugh@veritas.com> wrote:
> > > > 
> > > > Please find a better use for your time.
> > > > 
> > > > Imagine, there might be developers out there with real work
> > > > to do in these files: all you are doing is throwing silly
> > > > little obstacles in their way.
> > > 
> > > Actually, now is the right time to do such changes as we've just 
> > > pushed all pending x86 changes upstream. And since these changes 
> > > reduce the chance of future patch conflicts, they do help 
> > > development. (in a small way)
> > > 
> > > Nevertheless i'd suggest to make this a single commit, to not 
> > > clobber the shortlog with it.
> > > 
> > 
> > I think individual patches will be better option, in case of unavoidable
> > situation we can simply revert that particular patch.
> 
> What unavoidable situation ? That you broke stuff with your changes ?
> If you are so unsure about the quality of your changes, then the best
> option is to not pull that stuff at all.
> 

OK. Tree deleted, thanks for your advice.

--
JSR

