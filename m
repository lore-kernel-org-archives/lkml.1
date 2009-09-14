Return-Path: <linux-kernel-owner+w=401wt.eu-S1752168AbZINGfd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168AbZINGfd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 02:35:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751115AbZINGfb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 02:35:31 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:34267 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891AbZINGfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 02:35:31 -0400
Subject: Re: linux-next: manual merge of the tip tree with the slab tree
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Nick Piggin <npiggin@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <20090914155219.13118819.sfr@canb.auug.org.au>
References: <20090706144051.06d079a5.sfr@canb.auug.org.au>
	 <20090914155219.13118819.sfr@canb.auug.org.au>
Date: Mon, 14 Sep 2009 09:35:33 +0300
Message-Id: <1252910133.5934.3.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-09-14 at 15:52 +1000, Stephen Rothwell wrote:
> Hi Pekka,
> 
> On Mon, 6 Jul 2009 14:40:51 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> > Today's linux-next merge of the tip tree got a conflict in
> > include/linux/rcupdate.h between commit
> > 249acdd3fd13d1ec579ff9b1c5273cf5515cd352 ("SLQB slab allocator (try 2)")
> > from the slab tree and commit 03b042bf1dc14a268a3d65d38b4ec2a4261e8477
> > ("rcu: Add synchronize_sched_expedited() primitive") from the tip tree.
> > 
> > Just context changes. I fixed it up (see below) and can carry the fix as
> > necessary.
> 
> This conflict is now between the slab tree and Linus' tree.

OK, thanks Stephen, I'll fix it up in my tree.

