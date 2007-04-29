Return-Path: <linux-kernel-owner+w=401wt.eu-S1754535AbXD2Dkl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535AbXD2Dkl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 23:40:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754534AbXD2Dkl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 23:40:41 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49136
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754518AbXD2Dkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 23:40:39 -0400
Date: Sat, 28 Apr 2007 20:40:48 -0700 (PDT)
Message-Id: <20070428.204048.125894473.davem@davemloft.net>
To: mrechberger@gmail.com
Cc: torvalds@linux-foundation.org, bunk@stusta.de, diegocg@gmail.com,
       cebbert@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.21
From: David Miller <davem@davemloft.net>
In-Reply-To: <d9def9db0704281558r57460a6ft76bbddcc480058eb@mail.gmail.com>
References: <20070428195320.GZ3468@stusta.de>
	<alpine.LFD.0.98.0704281529080.9964@woody.linux-foundation.org>
	<d9def9db0704281558r57460a6ft76bbddcc480058eb@mail.gmail.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Markus Rechberger" <mrechberger@gmail.com>
Date: Sun, 29 Apr 2007 00:58:09 +0200

> On 4/29/07, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> >
> >
> > On Sat, 28 Apr 2007, Adrian Bunk wrote:
> > >
> > > We are already quite good at ignoring bug reports that come through
> > > linux-kernel, and it's an _advantage_ of the kernel Bugzilla to see more
> > > than 1600 open bugs because this tells how bad we are at handling bugs.
> >
> > No, it just shows that bugzilla doesn't matter for most of the kernel.
> >
> > Don't say that "bugzilla tells how bad we are at handling bugs". It tells
> > how bad *bugzilla* is for handling bugs, nothing more.
> >
> 
> I totally disagree here, bugzilla is a very good tool.

No, Bugzilla really does suck, and I personally refuse to use it when
I have a choice.  And guess what?  You better be concerned about that
because I maintain all of the networking code :-)

It puts the onus FAR too much on the developer and not enough on the
reporter and other minions.  We have a small resource of developers,
yet lots of users, bug reporters, and minions, so something that
doesn't take advantage of the larger resource we have is going to
not function efficiently at all.  Yet that is what bugzilla does.

It's made way too much work for me every time I'm come in contact with
it, it wastes my time instead of making good use of it.

As a developer I do not want to get pounded with emails containing
state changes and other bullshit that typically comes with being
assigned to or on the CC of a bugzilla entry.  I don't want to be
reminded that a bug hasn't been touched in weeks, if the reporter
doesn't care I don't care and I'll work on things that people do care
about.  It makes me delete all the bugzilla email, even the ones with
important information in them, because it's rediculious to have to
sift through all of that crap.

People only use bugzilla because it is well understood and nothing
better has reached critical mass yet.
