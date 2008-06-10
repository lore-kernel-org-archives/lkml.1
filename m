Return-Path: <linux-kernel-owner+w=401wt.eu-S1756142AbYFJJvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142AbYFJJvU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 05:51:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751938AbYFJJvF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 05:51:05 -0400
Received: from krynn.se.axis.com ([193.13.178.10]:46203 "EHLO
	krynn.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751714AbYFJJvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 05:51:02 -0400
Date: Tue, 10 Jun 2008 11:49:37 +0200
From: Jesper Nilsson <Jesper.Nilsson@axis.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: Hinko Ko??evar <hinko.kocevar@cetrtapot.si>,
       Mikael Starvik <mikael.starvik@axis.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       dev-etrax <dev-etrax@axis.com>, Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH 2.6.26-rc5 0/2] cris: compile fixes for 2.6.26-rc5
Message-ID: <20080610094937.GC4081@axis.com>
References: <4849213A.4080001@cetrtapot.si> <20080606183222.GE2201@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080606183222.GE2201@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 06, 2008 at 08:32:22PM +0200, Adrian Bunk wrote:
> On Fri, Jun 06, 2008 at 01:36:26PM +0200, Hinko Ko??evar wrote:
> > Hi,
> >
> > Current status of cris architecture is that current GIT tree at 2.6.26-rc5 does
> > not even compile.
> >...
> 
> @Mikael, Jesper:
> 
> BTW:
> What happened with the stuff you have?
> It seems you missed to merge for 2.6.26?

Yeah, unfortunately I got swamped just as the 2.6.26 merge window opened up.
I'll push them out for 2.6.27.

> Can you try to not miss the merge window for 2.6.27, and also publish
> your queued patches in a way that they might get into the -next tree
> (Stephen Cc'ed for possibly discussing details)?

Have I understood correctly that a tree exported for -next can be rebased
without causing any problems? I've hesitated a bit to create a -next tree
to avoid problems with later merges.

> > Best regards,
> > Hinko
> 
> TIA
> Adrian

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
