Return-Path: <linux-kernel-owner+w=401wt.eu-S935272AbYBWISD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935272AbYBWISD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 03:18:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765740AbYBWIJR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 03:09:17 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:48210 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933063AbYBWIIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 03:08:54 -0500
Date: Sat, 23 Feb 2008 00:04:01 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Miller <davem@davemloft.net>
Cc: viro@ZenIV.linux.org.uk, sfr@canb.auug.org.au, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: Tree for Feb 22
Message-Id: <20080223000401.d6b7d3e6.akpm@linux-foundation.org>
In-Reply-To: <20080221.233015.193695196.davem@davemloft.net>
References: <20080222170421.9e17d143.sfr@canb.auug.org.au>
	<20080222182116.b809022f.sfr@canb.auug.org.au>
	<20080222072554.GG27894@ZenIV.linux.org.uk>
	<20080221.233015.193695196.davem@davemloft.net>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Feb 2008 23:30:15 -0800 (PST) David Miller <davem@davemloft.net> wrote:

> From: Al Viro <viro@ZenIV.linux.org.uk>
> Date: Fri, 22 Feb 2008 07:25:54 +0000
> 
> > On Fri, Feb 22, 2008 at 06:21:16PM +1100, Stephen Rothwell wrote:
> > > On Fri, 22 Feb 2008 17:04:21 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > > >
> > > > Status of my local build tests is at
> > > > http://kisskb.ellerman.id.au/kisskb/branch/9/.  The sparc builds have
> > > > been mostly disabled while I obtain a working cross compiler.
> > > 
> > > I have reenabled the sparc and sparc64 builds but there is a bug in 32bit
> > > sparc (in Linus' tree) at the moment.
> > 
> > Remove includes of linux/rcupdate.h and linux/mm.h from memcontrol.h;
> > patch had been posted some time ago.
> 
> Yes, it's clogged up in Andrew's patch queue somewhere.

Yeah, sorry, Andrew's clogged up in airplanes.  I should get it out over
the weekend.

