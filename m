Return-Path: <linux-kernel-owner+w=401wt.eu-S1763217AbYEAS7I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763217AbYEAS7I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 14:59:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756426AbYEAS64
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 14:58:56 -0400
Received: from 1wt.eu ([62.212.114.60]:3687 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755555AbYEAS64 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 14:58:56 -0400
Date: Thu, 1 May 2008 20:58:46 +0200
From: Willy Tarreau <w@1wt.eu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: Re: Slow DOWN, please!!!
Message-ID: <20080501185846.GB30883@1wt.eu>
References: <20080429.190352.137408408.davem@davemloft.net> <200805011259.47343.rjw@sisk.pl> <alpine.LFD.1.10.0805010816340.5994@woody.linux-foundation.org> <200805011909.40203.rjw@sisk.pl> <alpine.LFD.1.10.0805011022370.5994@woody.linux-foundation.org> <20080501181157.GB5882@ZenIV.linux.org.uk> <alpine.LFD.1.10.0805011116060.5994@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805011116060.5994@woody.linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

our mails have crossed each other. Just to follow up in this thread just
in case...

On Thu, May 01, 2008 at 11:23:43AM -0700, Linus Torvalds wrote:
> So when we're looking at improvement suggestions, they should be real 
> suggestions that have realistic goals, not just wishes. And they 
> shouldn't be the things we *already* do, because then they wouldn't 
> be improvements.

as explained in last mail, I think that we're doing that far less than
we used to because of the ease of "Linus, please pull from git://master...".

> In other words: do people have realistic ideas for how to make others 
> spend _more_ time looking at patches? And not just _wishing_ people did 
> that?

As explained, I have no problem hijacking pull requests asking for 1) code
and 2) review if it's not explicitly stated in the message that it has been
reviewed, or that it is an obvious fix. I have no problem trusting the poster,
he should just care not to lie too often or will get a bad reputation of being
a blatant liar.

The only limit is that if I'm alone doing those raids, I'll quickly get into
all developer's blacklist and nothing will change. *YOU* too have to enforce
this policy.

Willy

