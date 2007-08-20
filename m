Return-Path: <linux-kernel-owner+w=401wt.eu-S1760250AbXHTPaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760250AbXHTPaZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 11:30:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756231AbXHTPaO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 11:30:14 -0400
Received: from embla.aitel.hist.no ([158.38.50.22]:42536 "EHLO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373AbXHTPaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 11:30:13 -0400
Message-ID: <46C9B2A9.1010904@aitel.hist.no>
Date: Mon, 20 Aug 2007 17:26:33 +0200
From: Helge Hafting <helge.hafting@aitel.hist.no>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Marc Perkel <mperkel@yahoo.com>
CC: Brennan Ashton <comphappy@gmail.com>, Nix <nix@esperi.org.uk>,
       Al Viro <viro@ftp.linux.org.uk>, Kyle Moffett <mrmacman_g4@mac.com>,
       Phillip Susi <psusi@cfl.rr.com>,
       Michael Tharp <gxti@partiallystapled.com>,
       LKML Kernel <linux-kernel@vger.kernel.org>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: Thinking outside the box on file systems
References: <465458.84259.qm@web52505.mail.re2.yahoo.com>
In-Reply-To: <465458.84259.qm@web52505.mail.re2.yahoo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Marc Perkel wrote:
> What's the point? People are openly hostile to new
> ideas here. I started out nice and laid out my ideas
> and you have a bunch of morons who attack anything
> new.

People here are not hostile to any new idea.  They are
generally hostile to anyone who suggest some
"improvement" that he wants others to actually implement.
Because that is acting like a boss, and you're not the boss here.

Also - what do you expect when you bring an idea and say
"well, don't look at what might go wrong, that's just
limitations of the existing parts of linux?"

Sure, everybody can overlook how your ideas don't fit into
current linux - but then they have nothing more to say.
What people here do is to look at new ideas/patches, and
point out problems with them.  When there are no more
problems left, the patch is applied and linux improves.

If we're not to point out problems with your ideas, then
they can't be used in linux.  That is not hostility, but how
linux development works.

Mostly people try to save you from doing unnecessary work -
so you don't go and implement a flawed filesystem that
will be rejected immediately when you show up with the patch.

Shooting down bad ideas saves tremendous amounts of work,
killing an idea at the discussion stage means the idea never
got to the much more labor-intensive implementation stage.

This don't mean that all new ideas are killed, only the bad ones.


If you want your ideas accepted, you'll have to come up
with something that isn't flawed, that is well planned, not
just a bunch of "well - we could do *that* perhaps" but then
it turns out that *that* idea was flawed as well.

Helge Hafting

Helge Hafting





