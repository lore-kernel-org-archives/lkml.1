Return-Path: <linux-kernel-owner+w=401wt.eu-S934998AbXGLQwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934998AbXGLQwV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 12:52:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759418AbXGLQwH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 12:52:07 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:58699 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453AbXGLQwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 12:52:05 -0400
Date: Fri, 13 Jul 2007 01:41:10 +0900 (JST)
Message-Id: <20070713.014110.39177276.tshibata@ab.jp.nec.com>
To: LeoLi@freescale.com
Cc: rob@landley.net, gh@us.ibm.com, hpa@zytor.com, kunai@linux-foundation.jp,
       holzheu@linux.vnet.ibm.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org,
       lf_kernel_messages@linux-founda.jp.nec.com, tshibata@ab.jp.nec.com,
       greg@kroah.com
Subject: Re: Documentation of kernel messages (Summary)
From: Tsugikazu Shibata <tshibata@ab.jp.nec.com>
In-Reply-To: <989B956029373F45A0B8AF0297081890F05F2F@zch01exm26.fsl.freescale.net>
References: <200707111413.03513.rob@landley.net>
	<989B956029373F45A0B8AF0297081890F05F2F@zch01exm26.fsl.freescale.net>
X-Mailer: Mew version 4.2 on Emacs 20.7 / Mule 4.1
 =?iso-2022-jp?B?KBskQjAqGyhCKQ==?=
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jul 2007 21:53:54 +0800, LeoLi wrote:
> On Thursday, July 12, 2007 2:13 AM Rob Landley wrote:
> > On Wednesday 11 July 2007 10:26:30 am Li Yang wrote:
> > > There are quite a lot kernel developers for each of the popular
> > > language, AFAIK.  For non-popular languages, there shouldn't be
> > > translation available in the first place.
> > 
> > I don't distinguish between "popular" and "non-popular" languages.  If
> > somebody's willing to do the translation work, it's popular.  If
> nobody's
> > willing to do the work, then even a language 1/3 of the planet's
> population
> > speaks isn't "popular" for kernel development.
> > 
> > I wouldn't discourage a translator into Klingon if they were willing
> to keep
> > their translation up to date and/or it actually resulted in patches.
> > 
> > > It was really a surprise when
> > > I post my Chinese translation on the LKML so many Chinese speakers
> have
> > > commented on the translation and encouraged the translation work.
> They
> > > are not visible as they usually don't talk too much.  :) So I set up
> the
> > > Chinese kernel development maillist(linux-kernel@zh-kernel.org),
> there
> > > will be more and more experienced kernel developer who can read and
> > > update the Chinese documents after they read the translated
> > > documentation and become kernel hacker.
> > 
> > The chinese mailing list is highly cool, and my first instinct was to
> note it
> > on kernel.org/doc, but it would be better if the chinese website I
> already
> > link to notes it instead.  (That way I don't have to worry about how
> to
> > spam-guard your email address. :)
> 
> The benefit of a localized maillist is that patches can be reviewed and
> commented in native language for common problems (like style, API).
> 
> > 
> > This also highlights the need for language maintainers to help the
> patches go
> > upstream to the english list.  (If we can avoid armchair commentators
> > saddling them with the task of translating the entire Documentation
> directory
> > and keeping such a translation up to date, we might actually get one
> too.
> > Fielding patches and questions sounds like plenty to me...)
> 
> I do think the documentation translation is very necessary even when
> there is a language maintainer, especially for the policy documents as
> HOWTO, codestyle , and etc.  The contributors should go through these
> policies and check their code for compliance before going to the
> language maintainer for help, or there will be too much for the language
> maintainer to translate.  The language maintainer doesn't need to
> translate all the documents himself, but he can help to coordinate the
> translation effort and help to make it update to date.

I would like to comment from Japanese situation.
I do also think the documentation translation is necessary even if
there are language maintainer are not there. HOWTO like very
fundamental documents will great help for early stage of developers.
The contributors/early stage of developer will be able to follow
coding style and so on if the documents are easy to read.

So, maintain this kind of document in local language are necessary
even if there are no language maintainer.

I believe the language maintainer should mostly take care about the
patch.

> > Could you ask on said list if anyone is likely to volunteer for the
> position?
> > (JUST translating patches and questions, as part of pushing code
> upstream.)
> 
> If we do need a contact person, I can do it.  However I don't think
> there will be much translation work to do here.  As I stated before,
> most Chinese programmers are more or less capable of read/write
> technical English.  The difficult part is to let them know the benefit
> of merging code in kernel and teach them how to do it.  That's why the
> policy documents in native language will be very useful.

I also think that most Japanese developers can read/write technical
English at some level.


> > > > Merging into the kernel is a great way to keep CODE up to date.
> Don't
> > > > think
> > > > it's magic pixie dust for documentation.  It never has been
> before.
> > >
> > > IMHO, having contribution merged into the kernel has the MAGIC to
> > > attract people to work for recognition.  When more and more people
> > > volunteer to work on it, the documentation will be up to date
> magically.
> > 
> > Obvious counter-arguments include the floppy driver, the floppy tape
> driver,
> > the tty layer, and most of the existing english Documentation
> directory...
> > 
> > I'll happily stay out of the way of people who actually want to merge
> > translations of documentation into the kernel.  I reserve the right to
> say "I
> > told you so" in about five years.
> > 
> > > > Ah, but It's not a language maintainer's job to update
> documentation.
> > > > It's
> > > > their job to ACCEPT PATCHES.  Translate patches, translate
> questions
> > > > back and
> > > > forth.  This has NOTHING to do with documentation unless they're
> > > > converting
> > > > documentation accompanying the patch one way; into english.
> > >
> > > Language maintainers can integrate updates to the documentation just
> > > like integrating any updates to the code.  Working on the
> documentation
> > > is ,IMHO, a perfect task for novice kernel hacker to get familiar
> with
> > > the process.
> > 
> > From a language maintainer's perspective documentation patches
> wouldn't be any
> > different than any other patches.  Translate the description and
> questions
> > going back and forth.  The patch itself doesn't get translated when
> it's C
> > and applies to scripts/kconfig/, why would it when it's UTF-8 and
> applies to
> > Documentation/?
> > 
> > Of course this brings up the question "what kind of function and
> variable
> > names do chinese people pick?"  (I honestly don't know, but I note
> that
> > attempts to use names that don't fit in 7-bit ascii would probably be
> frowned
> > upon in a big way...)
> > 
> > > It won't be too hard if the work is shared by a community.  Like the
> one
> > > I'm trying to establish.
> > 
> > A list works fine as a point of contact.  I note that in general,
> maintainers
> > are individuals (who delegate like mad, of course), because otherwise
> agenda
> > items languish with everyone thinking it's someone else's
> responsibility.
> 
> Got it.  I can do it as long as it doesn't consume too much time.  :)
> 
> > 
> > http://www.trumanlibrary.org/buckstop.htm
> > 
> > > - Leo
> > >
> > > Advertisement time:
> > > Chinese kernel development community http://zh-kernel.org    :)
> > 
> > Hmmm...  Now I'm wondering if I should link directly to the docs pages
> of the
> > chinese and japanese sites, or to the top level community pages?
> 
> The documents and maillist are also linked in the front page.  It's
> better to link the top level page.
> 
> - Leo
