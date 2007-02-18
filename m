Return-Path: <linux-kernel-owner+w=401wt.eu-S1752019AbXBRUUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752019AbXBRUUd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 15:20:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752021AbXBRUUd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 15:20:33 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3845 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752019AbXBRUUc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 15:20:32 -0500
Date: Sun, 18 Feb 2007 16:42:13 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Scott Preece <sepreece@gmail.com>
Cc: Theodore Tso <tytso@mit.edu>, v j <vj.linux@gmail.com>,
       Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: GPL vs non-GPL device drivers
Message-ID: <20070218164213.GB3945@ucw.cz>
References: <9b3a62ab0702142115m4ea7d2c0m6869eb64ef3ee14e@mail.gmail.com> <9b3a62ab0702142116n4069e16cl1bc8f546f41d935@mail.gmail.com> <20070215061149.GE15654@redhat.com> <9b3a62ab0702142227j19386132s870a0e745cfbb8d1@mail.gmail.com> <20070215165339.GB5285@thunk.org> <7b69d1470702151658w603aab4ave1d17cc0b2c40a2b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7b69d1470702151658w603aab4ave1d17cc0b2c40a2b@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >Contrawise, if Embedded developers do contribute their 
> >device driver
> >changes back to the kernel, they will be fine.  ...
> ---
> 
> In fairness, though, some of the developers WILL bitch 
> about your not
> using a recent kernel and not providing patches until 
> products ship,
> despite that meeting the letter of the license. Some of 
> the notes in

Well, of course developers will complain, they _always_ complain. But
it is very different kind of complain... first is

'I think you are violating the law, you are evil'

and second is

'Thank you for playing by the rules, but you know, your code is not
mergeable right now'.

> this thread do exactly that. And I HAVE seen real 
> developers say
> something very close to "Your code is based on a kernel 
> too old to
> have any value to us" even though they would also claim 
> abuse if the
> code hadn't been made available at all. And I've seen 

Yep, and guess what, thats okay. Someone with more time than they do
may decide to forward port the code and/or rewrite it for new kernel.

I was doing exactly that with 2.4 sharp sl-5500 code.

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
