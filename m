Return-Path: <linux-kernel-owner+w=401wt.eu-S1755528AbYC1MqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528AbYC1MqT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 08:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753931AbYC1MqH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 08:46:07 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:49674 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511AbYC1MqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 08:46:04 -0400
Date: Fri, 28 Mar 2008 06:46:03 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       "Luck, Tony" <tony.luck@intel.com>, linux-arch@vger.kernel.org,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: down_spin() implementation
Message-ID: <20080328124603.GR16721@parisc-linux.org>
References: <1FE6DD409037234FAB833C420AA843ECE9DF60@orsmsx424.amr.corp.intel.com> <20080327141508.GL16721@parisc-linux.org> <20080328155107.e9d8866c.sfr@canb.auug.org.au> <200803281603.34134.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803281603.34134.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 28, 2008 at 04:03:33PM +1100, Nick Piggin wrote:
> On Friday 28 March 2008 15:51, Stephen Rothwell wrote:
> > Hi Willy,
> >
> > On Thu, 27 Mar 2008 08:15:08 -0600 Matthew Wilcox <matthew@wil.cx> wrote:
> > > Stephen, I've updated the 'semaphore' tag to point ot the same place as
> > > semaphore-20080327, so please change your linux-next tree from pulling
> > > semaphore-20080314 to just pulling plain 'semaphore'.  I'll use this
> > > method of tagging from now on.
> >
> > Thanks. I read this to late for today's tree, but I will fix it up for
> > the next one.
> 
> Please don't add this nasty code to semaphore.
> 
> Did my previous message to the thread get eaten by spam filters?

It didn't arrive until after Stephen's message (but it did arrive before
this one).

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
