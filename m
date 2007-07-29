Return-Path: <linux-kernel-owner+w=401wt.eu-S965633AbXG2XjJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965633AbXG2XjJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 19:39:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965069AbXG2Xi5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 19:38:57 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:8177 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764558AbXG2Xi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 19:38:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=PkNTz8nVK3m9FPYIt+uE/9ITaKhBD0e4ZBo15chvwpo9dvQ1abefO9rYtzhZdDKe5jnjxV8G8flWPXuS8cxtxhJBOxTLElcZtoBX5jxgOjjaUU1LtvsLJhmI1kR+RWxWJ3HgxpRynRIskEMHX/JeEyQYPq3R764E+bxP7u8/HI8=
Message-ID: <a12e280d0707291638r484edbe4o14a67f35ded76eef@mail.gmail.com>
Date: Mon, 30 Jul 2007 09:38:56 +1000
From: "George Sescher" <gesacs@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: Linus 2.6.23-rc1
Cc: "Ingo Molnar" <mingo@elte.hu>, "Kasper Sandberg" <lkml@metanurb.dk>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "CK Mailinglist" <ck@vds.kolivas.org>
In-Reply-To: <alpine.LFD.0.999.0707291612410.3442@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org>
	 <1185588279.1654.1.camel@localhost> <20070729150436.GA6598@elte.hu>
	 <a12e280d0707291604s618c0b14lc8572b2f48cd4ca1@mail.gmail.com>
	 <alpine.LFD.0.999.0707291612410.3442@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 30 Jul 2007, George Sescher wrote:
> > <chuckle>
> >
> > You're advocating plugsched now?

On 30/07/07, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> I'd suggest people here take a look at the code. It's not what Ingo was
> saying, and it's not what the code is set up to do. He's just stating that
> the way he split up the files, it's actually easier from a patching
> standpoint to just create a new file to include instead of
> "kernel/sched_fair.c".

<snip long other discussion unrelated to my question>

Ingo's origiinal comment:

On 30/07/07, Ingo Molnar <mingo@elte.hu> wrote:
> i'd encourage you to do it - in fact i already tried to prod Peter
> Williams into doing exactly that ;) The more reality checks a scheduler
> has, the better.

He said having reality checks is a good thing. He's encouraging some
poor bastard to maintain plugsched out of mainline to have SD or
whatever to compare to. I did not say I advocated anything whatsoever.
I was asking if this is what Ingo is suggesting people use their
energy doing. Not good enough for mainline, but definitely worth
keeping around and good enough for... no idea what. I was asking Ingo
that.
