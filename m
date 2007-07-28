Return-Path: <linux-kernel-owner+w=401wt.eu-S936568AbXG1HhA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936568AbXG1HhA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 03:37:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759076AbXG1Hgx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 03:36:53 -0400
Received: from rv-out-0910.google.com ([209.85.198.191]:9737 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758138AbXG1Hgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 03:36:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Vc6g9Z7M2utGXkemqZi7xV/6pJRRfxT20Fw+VxKQ5o/tYvEX4fbxfijM0RgQbE5TQFobQnwwNTQHpkNhBfWelUdGAtglBeaBMDmFWTEWD1y5UToGNe6WbG2xHOKVk1fj3svsm+k5CcUS8GNZW0/qvgu5J0S+5gZi5xoNE9UEZ4Q=
Message-ID: <b21f8390707280036m6781856ckb64b5f10d2295fa5@mail.gmail.com>
Date: Sat, 28 Jul 2007 17:36:51 +1000
From: "Matthew Hawkins" <darthmdh@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [ck] Re: Linus 2.6.23-rc1
Cc: "Kasper Sandberg" <lkml@metanurb.dk>,
       "CK Mailinglist" <ck@vds.kolivas.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.0.999.0707271922050.3442@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org>
	 <1185588279.1654.1.camel@localhost>
	 <alpine.LFD.0.999.0707271922050.3442@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/28/07, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> People who think SD was "perfect" were simply ignoring reality. Sadly,
> that seemed to include Con too, which was one of the main reasons that I
> never ended entertaining the notion of merging SD for very long at all:
> Con ended up arguing against people who reported problems, rather than
> trying to work with them.

Not even Con thought SD was perfect, so this is being more than a
little dishonest.
One of his parting comments on the ck list was a list of things that
could be fixed/improved.

My experience is vastly different to yours, perhaps because I have
been subscribed to his mailing list for many years (too many to count)
and have run his patchset in various environments in that period - and
you have not.  Con was always very helpful to people experiencing
problems and did in fact work with them to get them resolved.  The
list is web-archived so everyone is free to go see that for
themselves.  He also tried to get others interested and involved in
kernel development at large.  SD itself went through 46 revisions
because of things people encountered using it, and it would have been
more still considering what Con had in the works had he not been
pushed out.

I can see how on LKML your viewpoint differs, though to be fair in my
recollection there was only one person Con argued with, and that man
is a belligerent troll.  Its my honest opinion that the problems that
troll encountered were completely made up, which is backed by the
evidence that no-one else had encountered or indeed could even
reproduce them.  I recall Con himself catching the troll out in a
lie-based "proof" on one occasion.  I'll hunt gmane for the link as I
believe people like that need to be exposed and stopped.  There
certainly was a lot of hot air and handwaving, and now that one other
tiny portion of Con's work has been raised its still going on.  Its
interesting that the same cycle repeats even when Con is no longer
involved, which proves Con could not have been the issue.

I'm sorry you in particular haven't been able to have the same
experience with Con as so many others have, especially considering who
you are and the weight your words have.  You've lost a really great
asset and aren't even aware of it.  That's really sad for everyone.

(fwiw the -ck list did a lot of the testing for CFS recently, and over
the years various other things too.  Generally a good bunch of folks
keen to try anything to make their Linux experience better.  And
definitely devoid of these petty politics and egos that are plagueing
other Linux-related lists.  You've not only lost Con, but perhaps one
of the better testbeds also).

-- 
Matt
