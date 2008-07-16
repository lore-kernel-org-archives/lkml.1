Return-Path: <linux-kernel-owner+w=401wt.eu-S1759120AbYGPDMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759120AbYGPDMY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 23:12:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758320AbYGPDMG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 23:12:06 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:52691 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757912AbYGPDMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 23:12:05 -0400
Date: Tue, 15 Jul 2008 23:11:57 -0400
To: Tiago Assumpcao <tiago@assumpcao.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, pageexec@freemail.hu,
       Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [stable] Linux 2.6.25.10
Message-ID: <20080716031157.GQ8185@mit.edu>
Mail-Followup-To: tytso@mit.edu, Tiago Assumpcao <tiago@assumpcao.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	pageexec@freemail.hu, Greg KH <greg@kroah.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, stable@kernel.org
References: <alpine.LFD.1.10.0807151425170.2867@woody.linux-foundation.org> <487D3C17.31467.1C3C0441@pageexec.freemail.hu> <alpine.LFD.1.10.0807151707450.2867@woody.linux-foundation.org> <487D4301.5080609@assumpcao.org> <alpine.LFD.1.10.0807151749570.2867@woody.linux-foundation.org> <487D4A7B.8090403@assumpcao.org> <alpine.LFD.1.10.0807151832260.2835@woody.linux-foundation.org> <487D5BD9.3080303@assumpcao.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <487D5BD9.3080303@assumpcao.org>
>From: Theodore Tso <tytso@mit.edu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: Theodore Tso <tytso@mit.edu>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2008 at 11:24:25PM -0300, Tiago Assumpcao wrote:
>> The people who want to track security issues don't run my development  
>> kernels. They usually don't even run the _stable_ kernels. They tend to 
>> run the kernels from some commercial distribution, and usually one that 
>> is more than six months old as far as I - and other kernel developers - 
>> are concerned.
>
> Right *there* is where it is born! Right at your development kernels. It  
> may or may not survive up to the big market. However, being at the  
> source level, it is your duty to a) resolve the source-level issues; b)  
> put affordable efforts in order to prevent one known issue to arrive at  
> the end point.

I don't think we've ever heard any of the distro kernel engineers
complain that there is a problem with how commits are documented in
the upstream source.  Keep in mind, the distro kernels are usually at
least 6-9, to sometimes 18-24 months old.  So many of the security
bugs that show up in the developement kernels simply don't *apply* to
the distro kernels; they security bugs simply aren't present in those
older kernels.

Of course, sometimes there are long-standing bugs.  But I don't think
the distro engineers have been complaining that they aren't finding
out about them because they aren't marked <<------ SECURITY BUG HERE
in big bold letters.

And again, talking about something as if it were their ***duty*** is
not a good way to pursuade people to do things in the open source
world.  The only guaranteed way to get something done in the open
source is to help pay for it, or do it yourself.  Sometimes you can
convince others to do your work for you, but usually that requires
some reciprocity in the long run.

Regards,

						- Ted
