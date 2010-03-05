Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735Ab0CERTr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 12:19:47 -0500
Received: from thunk.org ([69.25.196.29]:45801 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753261Ab0CERTq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 12:19:46 -0500
Date: Fri, 5 Mar 2010 12:19:29 -0500
From: tytso@mit.edu
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, daniel@fooishbar.org,
       skeggsb@gmail.com, airlied@linux.ie, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org, dri-devel@lists.sf.net, mingo@elte.hu
Subject: Re: [git pull] drm request 3
Message-ID: <20100305171929.GD6000@thunk.org>
Mail-Followup-To: tytso@mit.edu, Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	David Miller <davem@davemloft.net>, daniel@fooishbar.org,
	skeggsb@gmail.com, airlied@linux.ie, linux-kernel@vger.kernel.org,
	jbarnes@virtuousgeek.org, dri-devel@lists.sf.net, mingo@elte.hu
References: <20100305151754.GB2505@tempa>
 <20100305.072612.186421758.davem@davemloft.net>
 <20100305154009.GC2505@tempa>
 <20100305.074835.159078083.davem@davemloft.net>
 <20100305160217.663413eb@lxorguk.ukuu.org.uk>
 <alpine.LFD.2.00.1003050810140.3788@localhost.localdomain>
 <20100305162327.084d4038@lxorguk.ukuu.org.uk>
 <alpine.LFD.2.00.1003050832250.3788@localhost.localdomain>
 <20100305170414.46acfb8f@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100305170414.46acfb8f@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 05, 2010 at 05:04:14PM +0000, Alan Cox wrote:
> You can only see it as malicious if you assume they ever had some reason
> to keep compatibility or had promised it somewhere. Quite the reverse
> happened, and they never asked to be upstream in the first place.

The reason why this thread is inspiring so much traffic is because
it's fundamentally about community norms.  There are plenty of things
that are not illegal, but which are at the same time anti-social.

For example, there are all sorts of rules, if you are a researcher,
about experimenting on human subjects.  Many of those restrictions
aren't codified in law, but if you violate them, other researches will
say that you are a bad person, a bad researcher, and refuse to
associate with you.  And you might well lose your funding in the
future --- but it's not illegal.

If we are only talking about obligations under the GPL, sure, no one
violated copyright licenses.  But what *did* happen is someone
basically said, "I want to experiment on a whole bunch of users, but I
don't want to spend the effort to do things in the right way.  I want
to take short cuts; I don't want to worry about the fact that it will
be impossible to test kernels without pulling Frankenstein
combinations of patches between Fedora 13 and Fedora 12."  It's much
like people who drill oil in the Artic Ocean, but use single-hulled
tankers and then leave so much toxic spillage in their wake, but then
say, "hey, the regulations said what we did was O.K. Go away; don't
bother us."


Distro's that want to have a good reputation need to have a higher
standard than, "hey, it's allowed by the GPL."  And maybe if we are
sinking to the point where people are going to use "stable means ABI
breakages are allowed", we need to change the rules, since people want
to quote rules as opposed to just being good community members.  If
you want lots of testers, then you need to be treat the testers, and
the other developers in our development community with respect.

I think the real problem was that Fedora and the Neauveu community are
acting incredibly selfishly.  They only care about their narrow point
of view, and don't care about the pain they are inflicting on the
kernel development process and other kernel developers.  This is
_legal_.  It is, however, anti-social.

       		   	     	     		- Ted
