Return-Path: <linux-kernel-owner+w=401wt.eu-S1757896AbXHRSU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757896AbXHRSU3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 14:20:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756711AbXHRSUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 14:20:17 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:50819 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756625AbXHRSUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 14:20:12 -0400
Date: Sat, 18 Aug 2007 19:19:59 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Marc Perkel <mperkel@yahoo.com>
Cc: Kyle Moffett <mrmacman_g4@mac.com>, Phillip Susi <psusi@cfl.rr.com>,
       Valdis.Kletnieks@vt.edu, Michael Tharp <gxti@partiallystapled.com>,
       alan <alan@clueserver.org>, LKML Kernel <linux-kernel@vger.kernel.org>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: Thinking outside the box on file systems
Message-ID: <20070818181959.GP21089@ftp.linux.org.uk>
References: <DDABDE40-EDA1-421A-A3D9-2CE48802A125@mac.com> <675612.55480.qm@web52503.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <675612.55480.qm@web52503.mail.re2.yahoo.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 18, 2007 at 09:45:54AM -0700, Marc Perkel wrote:
 
> Linux isn't going to make progress when people try to
> figure out how to make something NOT work rather than
> to make something work. So if you are going to put
> effort into this then why not try to figure out how to
> get around the issues you are raising rather than to
> attack the idea as unsolvable.

It's your idea; _you_ get to defend it against the problems found by
reviewers.  And whining about negativity is the wrong way to do that.
Look at it that way: there is science and there is feel-good woo.
The former depends on peer review.  The latter depends on not having
it and vague handwaving is the classical way of avoiding it.  So are
the claims of being a "visionary" and accusing critics of being uncooperative
reactionaries conspiring against the progress.

So far you are doing very poorly; if you want somebody else to join
you in experimenting with these ideas, you are acting in a very
inefficient way (and if you don't want anybody else, you'll obviously
have to deal with details yourself anyway).  Asserting that critics
should patch the holes in your handwaving is unlikely to impress anybody;
arrogance is not in short supply around here and yours is not even
original.
