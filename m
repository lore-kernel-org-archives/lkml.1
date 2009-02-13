Return-Path: <linux-kernel-owner+w=401wt.eu-S1757965AbZBMJU7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757965AbZBMJU7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 04:20:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750846AbZBMJUn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 04:20:43 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:40554 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800AbZBMJUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 04:20:41 -0500
Subject: Re: git-send-email
From: Peter Zijlstra <peterz@infradead.org>
To: Junio C Hamano <junio@pobox.com>
Cc: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Ingo Oeser <ioe-lkml@rameria.de>, L-K <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <7vmycrf5dv.fsf@gitster.siamese.dyndns.org>
References: <1234451714.10603.22.camel@laptop>
	 <200902121825.35021.ioe-lkml@rameria.de>
	 <20090212192104.GD15809@csclub.uwaterloo.ca>
	 <7vmycrf5dv.fsf@gitster.siamese.dyndns.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 13 Feb 2009 10:22:38 +0100
Message-Id: <1234516958.6519.6.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-12 at 18:16 -0800, Junio C Hamano wrote:
> lsorense@csclub.uwaterloo.ca (Lennart Sorensen) writes:
> 
> > On Thu, Feb 12, 2009 at 06:25:34PM +0100, Ingo Oeser wrote:
> >> No, they are great, if you like to skip over a topic, you are not
> >> interested in at all!
> >> 
> >> If you don't like it, just switch off thread in your mailer and
> >> don't force this on everybody else!
> >
> > Actually if (as apparently many people seem to manage to do) you have a
> > single starting email, with all the patches as replies to that first
> > email, it looks a lot better, and is much easier to follow.
> >
> > Seperate threads would be bad.
> >
> > foobar patch 0 (usually a summary/overview)
> > +-foobar patch 1
> > +-foobar patch 2
> > +-foobar patch 3
> > +-foobar patch 4
> > +-foobar patch 5
> >
> > is much nicer than
> >
> > foobar patch 0
> > +-foobar patch 1
> >   +-foobar patch 2
> >     +-foobar patch 3
> >       +-foobar patch 4
> >         +-foobar patch 5
> >
> > which seems to be what git does itself.
> 
> I personally prefer the former, but as you hopefully all found out by now,
> the choice between these two is just the matter of personal taste, and
> there is no clear majority.
> 
> The default will not going to change.

Its a matter of usability, the inf deep chain git does by default
renders the result unusable. Fact is I usually skip over patch series
posted that way, simply because its too much of a bother.

If you can't be bothered with usability of your project, then so be it.
Maybe all those rants on how unusable git is have a point after all.
