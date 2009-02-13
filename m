Return-Path: <linux-kernel-owner+w=401wt.eu-S1758910AbZBMJ2l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758910AbZBMJ2l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 04:28:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751422AbZBMJ2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 04:28:33 -0500
Received: from 1wt.eu ([62.212.114.60]:2222 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751363AbZBMJ2b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 04:28:31 -0500
Date: Fri, 13 Feb 2009 10:27:37 +0100
From: Willy Tarreau <w@1wt.eu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Junio C Hamano <junio@pobox.com>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Ingo Oeser <ioe-lkml@rameria.de>, L-K <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: git-send-email
Message-ID: <20090213092737.GO5038@1wt.eu>
References: <1234451714.10603.22.camel@laptop> <200902121825.35021.ioe-lkml@rameria.de> <20090212192104.GD15809@csclub.uwaterloo.ca> <7vmycrf5dv.fsf@gitster.siamese.dyndns.org> <1234516958.6519.6.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234516958.6519.6.camel@twins>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Fri, Feb 13, 2009 at 10:22:38AM +0100, Peter Zijlstra wrote:
> On Thu, 2009-02-12 at 18:16 -0800, Junio C Hamano wrote:
> > lsorense@csclub.uwaterloo.ca (Lennart Sorensen) writes:
> > 
> > > On Thu, Feb 12, 2009 at 06:25:34PM +0100, Ingo Oeser wrote:
> > >> No, they are great, if you like to skip over a topic, you are not
> > >> interested in at all!
> > >> 
> > >> If you don't like it, just switch off thread in your mailer and
> > >> don't force this on everybody else!
> > >
> > > Actually if (as apparently many people seem to manage to do) you have a
> > > single starting email, with all the patches as replies to that first
> > > email, it looks a lot better, and is much easier to follow.
> > >
> > > Seperate threads would be bad.
> > >
> > > foobar patch 0 (usually a summary/overview)
> > > +-foobar patch 1
> > > +-foobar patch 2
> > > +-foobar patch 3
> > > +-foobar patch 4
> > > +-foobar patch 5
> > >
> > > is much nicer than
> > >
> > > foobar patch 0
> > > +-foobar patch 1
> > >   +-foobar patch 2
> > >     +-foobar patch 3
> > >       +-foobar patch 4
> > >         +-foobar patch 5
> > >
> > > which seems to be what git does itself.
> > 
> > I personally prefer the former, but as you hopefully all found out by now,
> > the choice between these two is just the matter of personal taste, and
> > there is no clear majority.
> > 
> > The default will not going to change.
> 
> Its a matter of usability, the inf deep chain git does by default
> renders the result unusable. Fact is I usually skip over patch series
> posted that way, simply because its too much of a bother.
> 
> If you can't be bothered with usability of your project, then so be it.
> Maybe all those rants on how unusable git is have a point after all.

While your last comment seems a bit excessive to me, I agree with you
about the threading problem. I have to turn threads off to read some
of these long mails because the subject does not fit in my terminal,
and most of the time I only see just something like '[PATCH' which is
pretty useless.

The former mode (as used by Greg when he posts his huge stable series)
is a lot more convenient. Also, if one mail gets dropped for whatever
reason in between, the threading is not broken.

Regards,
Willy

