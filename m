Return-Path: <linux-kernel-owner+w=401wt.eu-S1752954AbZGJDgr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954AbZGJDgr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 23:36:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751748AbZGJDgi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 23:36:38 -0400
Received: from kroah.org ([198.145.64.141]:38567 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751420AbZGJDgi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 23:36:38 -0400
Date: Thu, 9 Jul 2009 20:35:20 -0700
From: Greg KH <greg@kroah.com>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       David Howells <dhowells@redhat.com>, benh@kernel.crashing.org,
       paulus@samba.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
       jdike@addtoit.com, Ingo Molnar <mingo@elte.hu>,
       x86 maintainers <x86@kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       David Miller <davem@davemloft.net>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       dbrownell@users.sourceforge.net, mchehab@infradead.org,
       jeremy@xensource.com, felixb@sgi.com, lenb@kernel.org, airlied@linux.ie,
       bcrl@kvack.org, Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
       Russell King <rmk+lkml@arm.linux.org.uk>
Subject: Re: [GIT-PULL] includecheck fixes
Message-ID: <20090710033520.GA2458@kroah.com>
References: <1247063308.4382.12.camel@ht.satnam>
 <1247164809.2452.9.camel@ht.satnam>
 <20090709222626.GA32746@kroah.com>
 <1247194755.2423.7.camel@ht.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247194755.2423.7.camel@ht.satnam>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 10, 2009 at 08:29:15AM +0530, Jaswinder Singh Rajput wrote:
> Hello Greg,
> 
> On Thu, 2009-07-09 at 15:26 -0700, Greg KH wrote:
> > On Fri, Jul 10, 2009 at 12:10:09AM +0530, Jaswinder Singh Rajput wrote:
> > > Linus,
> > > 
> > > Please pull includecheck fixes, these all are clean and safe patches
> > > with relevant Acks.
> > 
> > Shouldn't stuff like this go through the trivial tree?  And stuff like
> > that is relevant for the main pre-rc1 merge, not this late in the merge
> > cycle, right?
> > 
> 
> You did not specified what is your problem ? and where was you when we
> discussed it earlier ?

Earlier when?  I responded to your query about the individual patches
you copied me on, saying they were in my "to-apply" queue and I didn't
want them to go to Linus at this point in time.  You seem quite rushed
about these patches, which is odd to me.

> Normally brain is above then the eyes, do you know why ?
> 
> To use your brain instead of follow things blindly.
> 
> The point of watching patches for some time means test and wait so that
> they can show their real faces.

Which is what I am asking you to do here.  So why are you arguing with
this concept?

> BTW, it is not late, it is not going to hit stable in next week or so.
> 
> Keeping these sane patches waiting for complete cycle will be insaner.

Accepting trivial patches like these, for which a full build cycle of
all arches has yet to be accomplished due to a lack of inclusion in the
-next tree, at a point in the development series in which bug fixes and
regressions are the only thing to be accepted, seems to be a risk, don't
you think?

But hey, I'm not Linus, it's up to him to decide to take untested stuff
like this or not, not me :)

best of luck,

greg k-h
