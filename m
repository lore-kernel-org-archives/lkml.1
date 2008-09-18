Return-Path: <linux-kernel-owner+w=401wt.eu-S1757262AbYIRUcq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757262AbYIRUcq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 16:32:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757143AbYIRUcg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 16:32:36 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:52489 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756531AbYIRUcf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 16:32:35 -0400
Subject: Re: mmotm 2008-09-13-03-09 uploaded
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080919035248.d3187001.sfr@canb.auug.org.au>
References: <200809131011.m8DABTON031878@imap1.linux-foundation.org>
	 <20080918150115.1aa45123.kamezawa.hiroyu@jp.fujitsu.com>
	 <20080917232648.5b991958.akpm@linux-foundation.org>
	 <1221727868.6892.66.camel@odin>
	 <20080918022353.dca4b5c3.akpm@linux-foundation.org>
	 <20080919035248.d3187001.sfr@canb.auug.org.au>
Content-Type: text/plain
Date: Thu, 18 Sep 2008 21:32:38 +0100
Message-Id: <1221769958.6892.80.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-09-19 at 03:52 +1000, Stephen Rothwell wrote:
> Hi Andrew, Liam,
> 
> On Thu, 18 Sep 2008 02:23:53 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > > Can I just confirm the repository & branch you are pulling as I've
> > > recently left Wolfson and now work for myself (I will no longer have
> > > guaranteed access to the Wolfson git repositories). I've also moved
> > > regulator development over to kernel.org:-
> > > 
> > > git://git.kernel.org/pub/scm/linux/kernel/git/lrg/voltage-2.6.git #dev
> > > 
> > 
> > Please send that off to Stephen for linux-next inclusion.
> 
> I have this:
> 
> Liam Girdwood <lg@opensource.wolfsonmicro.com>
> voltage git://git.kernel.org/pub/scm/linux/kernel/git/lrg/voltage-2.6.git#reg-for-linus
> 
> in the linux-next list already.  Do I assume that some changes are needed
> (email and branch)?
> 

Yes, email and branch have changed.

For next it should be :-

Liam Girdwood <lrg@slimlogic.co.uk>
voltage git://git.kernel.org/pub/scm/linux/kernel/git/lrg/voltage-2.6.git#for-linus

Thanks

Liam

