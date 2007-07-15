Return-Path: <linux-kernel-owner+w=401wt.eu-S1760706AbXGOOmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760706AbXGOOmU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 10:42:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757512AbXGOOmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 10:42:10 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:18020 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757708AbXGOOmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 10:42:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=iJmAz+cNIqSTSMSc6PhDZEkrD4AXv7OKc4oDgvy6oIWSvrpgQR0iywQ9tHqK/unwjTgc4QxmpPmczBdVE/VR0FuFZ5l0599rasj6gZBl3GKs/X5JmyOByA2LiA6QdQp3k1hcftcKRYW5hnme8hjc0ctB/CPGgYYM+DyRAYCU2U4=
Message-ID: <a0bc9bf80707150742kf217ff3g8dc65efccfa692cc@mail.gmail.com>
Date: Sun, 15 Jul 2007 22:42:07 +0800
From: "Li Yang" <leo@zh-kernel.org>
To: "Rob Landley" <rob@landley.net>
Subject: Re: [PATCH] Chinese Language Maintainer
Cc: "Gerrit Huizenga" <gh@us.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>,
       "Kunai, Takashi" <kunai@linux-foundation.jp>,
       holzheu@linux.vnet.ibm.com, "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, lf_kernel_messages@linux-foundation.org,
       mtk-manpages@gmx.net, jack@suse.cz, randy.dunlap@oracle.com,
       gregkh@suse.de, pavel@ucw.cz, tim.bird@am.sony.com, arjan@infradead.org,
       sam@ravnborg.org, jengelh@computergmbh.de, joe@perches.com,
       auke-jan.h.kok@intel.com, hansendc@us.ibm.com, davem@davemloft.net,
       Valdis.Kletnieks@vt.edu, kenistoj@us.ibm.com, schwidefsky@de.ibm.com,
       heiko.carstens@de.ibm.com, linux-doc@vger.kernel.org
In-Reply-To: <200707131352.12952.rob@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <989B956029373F45A0B8AF0297081890F05F2F@zch01exm26.fsl.freescale.net>
	 <200707121205.20959.rob@landley.net>
	 <1184330583.23373.65.camel@Gundam>
	 <200707131352.12952.rob@landley.net>
X-Google-Sender-Auth: faa2d1b6a27b9904
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/14/07, Rob Landley <rob@landley.net> wrote:
> On Friday 13 July 2007 8:43:03 am Li Yang wrote:
> > On Thu, 2007-07-12 at 12:05 -0400, Rob Landley wrote:
> > > +A language maintainer accepts patches to the Linux kernel, written in C,
> > > from +authors who do not also speak English.  The language maintainer
> > > translates the +description of each patch into English, forwards the
> > > patches to linux-kernel +and to the appropriate maintainers for inclusion
> > > in the Linux kernel, and +translates questions and replies about such
> > > patches as part of the +patch review process.
> >
> > In addiction to this responsibility, I would like to add two more which,
> > in my opinion, are more important.  And these are what I'm trying to
> > do.  :)
> > First, promoting contribution to Linux kernel in local language.
> > Second, coordinate the translation effort of key kernel documents.
>
> Cool.  It's good to do that, but not the problem I'm worried about solving.
>
> I was trying to describe the minimum requirements for being a language
> maintainer, I.E. what non-english users need in order to be able to merge
> their patches.  Because without someone to contribute patches to (I.E a
> language maintainer), documentation in non-english languages promotes the
> creation of patches that can't be merged.  That's the problem I'm trying to
> solve.
>
> To me, finding language maintainers is the flip side of the coin of
> translating documentation.

I think you worried too much about this problem.  :)  Let me explain
the situation here in China more clearly.  Actually, English is
mandatory in most schools and universities.  Only very few people
learn other language as a second language.  Therefore software
developers who are almost educated should have the basic English
skill.  However, that doesn't mean that they can read English or
communicate with native English speaker very easily.  Consider your
second language learn in school for analogy.  Read in English will be
much slower and more likely to cause misunderstanding.  This will
reduce the likelihood greatly of English documentation being read.  If
we are promoting contribution to the Linux community, we should
maximum the possibility that these key documents being read.
Translation will serve this purpose very well.

So the possibility is very little that a translator is needed between
the Linux maintainer and a Chinese developer.  Although sometimes help
is needed when there is misunderstanding.

After a brief talk with the Japanese translator, I think the case is
similar for Japanese too.

Therefore, in my opinion, language maintainer should be more a helper
and promoter rather than a gatekeeper.  I will give a proposed process
later about how this helper mechanism works.

- Leo
