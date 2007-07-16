Return-Path: <linux-kernel-owner+w=401wt.eu-S1762921AbXGPC7H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762921AbXGPC7H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 22:59:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759234AbXGPC64
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 22:58:56 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:62869 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758999AbXGPC6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 22:58:55 -0400
Date: Mon, 16 Jul 2007 11:49:48 +0900 (JST)
Message-Id: <20070716.114948.48508930.tshibata@ab.jp.nec.com>
To: leo@zh-kernel.org
Cc: rob@landley.net, gh@us.ibm.com, hpa@zytor.com, kunai@linux-foundation.jp,
       holzheu@linux.vnet.ibm.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, lf_kernel_messages@linux-foundation.org,
       tshibata@ab.jp.nec.com
Subject: Re: [PATCH] Chinese Language Maintainer
From: Tsugikazu Shibata <tshibata@ab.jp.nec.com>
In-Reply-To: <a0bc9bf80707150742kf217ff3g8dc65efccfa692cc@mail.gmail.com>
References: <1184330583.23373.65.camel@Gundam>
	<200707131352.12952.rob@landley.net>
	<a0bc9bf80707150742kf217ff3g8dc65efccfa692cc@mail.gmail.com>
X-Mailer: Mew version 4.2 on Emacs 20.7 / Mule 4.1
 =?iso-2022-jp?B?KBskQjAqGyhCKQ==?=
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 15 Jul 2007 22:42:07 +0800, leo wrote:
> On 7/14/07, Rob Landley <rob@landley.net> wrote:
> > On Friday 13 July 2007 8:43:03 am Li Yang wrote:
> > > On Thu, 2007-07-12 at 12:05 -0400, Rob Landley wrote:
> > > > +A language maintainer accepts patches to the Linux kernel, written in C,
> > > > from +authors who do not also speak English.  The language maintainer
> > > > translates the +description of each patch into English, forwards the
> > > > patches to linux-kernel +and to the appropriate maintainers for inclusion
> > > > in the Linux kernel, and +translates questions and replies about such
> > > > patches as part of the +patch review process.
> > >
> > > In addiction to this responsibility, I would like to add two more which,
> > > in my opinion, are more important.  And these are what I'm trying to
> > > do.  :)
> > > First, promoting contribution to Linux kernel in local language.
> > > Second, coordinate the translation effort of key kernel documents.
> >
> > Cool.  It's good to do that, but not the problem I'm worried about solving.
> >
> > I was trying to describe the minimum requirements for being a language
> > maintainer, I.E. what non-english users need in order to be able to merge
> > their patches.  Because without someone to contribute patches to (I.E a
> > language maintainer), documentation in non-english languages promotes the
> > creation of patches that can't be merged.  That's the problem I'm trying to
> > solve.
> >
> > To me, finding language maintainers is the flip side of the coin of
> > translating documentation.
> 
> I think you worried too much about this problem.  :)  Let me explain
> the situation here in China more clearly.  Actually, English is
> mandatory in most schools and universities.  Only very few people
> learn other language as a second language.  Therefore software
> developers who are almost educated should have the basic English
> skill.  However, that doesn't mean that they can read English or
> communicate with native English speaker very easily.  Consider your
> second language learn in school for analogy.  Read in English will be
> much slower and more likely to cause misunderstanding.  This will
> reduce the likelihood greatly of English documentation being read.  If
> we are promoting contribution to the Linux community, we should
> maximum the possibility that these key documents being read.
> Translation will serve this purpose very well.
> 
> So the possibility is very little that a translator is needed between
> the Linux maintainer and a Chinese developer.  Although sometimes help
> is needed when there is misunderstanding.
> 
> After a brief talk with the Japanese translator, I think the case is
> similar for Japanese too.

Yes, In Japan, situation is mostly the same.
We are trying to increase number of Linux community developer with
Linux Foundation Japan or CELF people in Japan.
In our discussion, the problem is not only Language.

In case of some developer, once he step forward (he try to send patch
or comment on LKML), he got some comment and he can work with
community even if it's slow (because of he was non-native).
So, I thought if some key document are available in Japanese like
HOWTO, that will help such early stage of developers.

> Therefore, in my opinion, language maintainer should be more a helper
> and promoter rather than a gatekeeper.  I will give a proposed process
> later about how this helper mechanism works.

I will be able to help this as a stand point of Japanese situation.

> - Leo
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
