Return-Path: <linux-kernel-owner+w=401wt.eu-S1761538AbYEAS2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761538AbYEAS2U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 14:28:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754285AbYEAS2H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 14:28:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55423 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752401AbYEAS2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 14:28:06 -0400
Date: Thu, 1 May 2008 11:23:43 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, Willy Tarreau <w@1wt.eu>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: Re: Slow DOWN, please!!!
In-Reply-To: <20080501181157.GB5882@ZenIV.linux.org.uk>
Message-ID: <alpine.LFD.1.10.0805011116060.5994@woody.linux-foundation.org>
References: <20080429.190352.137408408.davem@davemloft.net> <200805011259.47343.rjw@sisk.pl> <alpine.LFD.1.10.0805010816340.5994@woody.linux-foundation.org> <200805011909.40203.rjw@sisk.pl> <alpine.LFD.1.10.0805011022370.5994@woody.linux-foundation.org>
 <20080501181157.GB5882@ZenIV.linux.org.uk>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 1 May 2008, Al Viro wrote:
> On Thu, May 01, 2008 at 10:41:21AM -0700, Linus Torvalds wrote:
> > 
> > Same goes for "we should all just spend time looking at each others 
> > patches and trying to find bugs in them". That's not a solution, that's a 
> > drug-induced dream you're living in.
> 
> As one of those obviously drug-addled freaks who _are_ looking for bugs...
> Thank you so fucking much ;-/

That's not what I meant, and I think you know it.

Of course as many people as possible should look at other peoples patches 
and comment on them. But saying so won't _make_ it so.  And it's also 
something that we have done since day #1 _anyway_, so anybody who thinks 
that it would improve code quality from where we already are, should 
explain how he thinks the increase would be caused, and how it would 
happen.

So when we're looking at improvement suggestions, they should be real 
suggestions that have realistic goals, not just wishes. And they 
shouldn't be the things we *already* do, because then they wouldn't 
be improvements.

In other words: do people have realistic ideas for how to make others 
spend _more_ time looking at patches? And not just _wishing_ people did 
that?

			Linus
