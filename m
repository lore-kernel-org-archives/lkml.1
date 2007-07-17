Return-Path: <linux-kernel-owner+w=401wt.eu-S937187AbXGQXky@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937187AbXGQXky (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 19:40:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758248AbXGQXkp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 19:40:45 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:61165 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759309AbXGQXko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 19:40:44 -0400
Date: Wed, 18 Jul 2007 08:30:48 +0900 (JST)
Message-Id: <20070718.083048.74751281.tshibata@ab.jp.nec.com>
To: rob@landley.net
Cc: LeoLi@freescale.com, gh@us.ibm.com, hpa@zytor.com,
       kunai@linux-foundation.jp, holzheu@linux.vnet.ibm.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       lf_kernel_messages@linux-foundation.org, tshibata@ab.jp.nec.com
Subject: Re: Documentation of kernel messages (Summary)
From: Tsugikazu Shibata <tshibata@ab.jp.nec.com>
In-Reply-To: <200707171206.56805.rob@landley.net>
References: <200707142212.35874.rob@landley.net>
	<20070716.014642.41651135.tshibata@ab.jp.nec.com>
	<200707171206.56805.rob@landley.net>
X-Mailer: Mew version 4.2 on Emacs 20.7 / Mule 4.1
 =?iso-2022-jp?B?KBskQjAqGyhCKQ==?=
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jul 2007 12:06:56 -0400, rob wrote:
> On Sunday 15 July 2007 12:46:42 pm Tsugikazu Shibata wrote:
> > On Sat, 14 Jul 2007 22:12:35 -0400, rob wrote:
> > > On Friday 13 July 2007 9:46:59 pm Tsugikazu Shibata wrote:
> > > > > > How about adding;
> > > > > > kernel-doc-nano-HOWTO.txt
> > > > >
> > > > > The problem is, the generated htmdocs are in english.  This file is
> > > > > about how to generate (and author) English documentation that won't
> > > > > be translated. What's the point of translating the instructions if
> > > > > the result won't be translated?
> > > >
> > > > People (who even in non-native) would better to know and read it such
> > > > htmldocs because there are good and important documents even in
> > > > English. I thought that translation of this file may help.
> > >
> > > The english version of htmldocs is generated from the source code.    If
> > > translating remotely current versions of htmldocs into other languages
> > > was feasible, then the english version wouldn't need to be in the source
> > > code in the first place.
> > >
> > > Translating a document _about_ htmldocs boils down to "Dear non-english
> > > speaker: here's something you can't read, nor can you update it either
> > > except though your language maintainer."
> >
> > No, kernel-doc-nano-HOWTO includes explanation of tools to extract the
> > document, format of extractable document in source files and so on.
> > I thought this file would help non-native people, how to extract or add
> > in-kernel extractable documents.
> 
> Which will be in english, so why can't the instructions on how to do it be in 
> english too?
> 
> > I understand that these tools will generate English documents but
> > that's OK.
> 
> Then the instructions how to do it in english should be ok too.  If they can't 
> read the instructions, they won't be able to read the result.

It seems my explanation was not enough.
We (like me, usually not using English) can read English but it takes
more time than you (and any natives). So, reading large document takes
huge amount of time. In case of htmldocs, it is actually large and
developer may give up before start.
I thought that if some part (like how to do it) are translated into
his/her familiar language, he/she may not give it up.
Yes, it may not be.

Another viewpoint is that if he/she need to modify some interface and
it may need to change some part of extractable document, this file
includes, "How to add extractable documentation to your source files".
It will be some help as well. 
Yes, He/she should write English and it may take long time but hopefully
the translation result would push his/her back. 


> > Such large volume of documents are not easy to translate 
> > into other languages.
> 
> "Here's how to get a result that will be useless to you."
> 
> Why?  What's the point?  I'm not seeing it.
> 
> Rob
> -- 
> "One of my most productive days was throwing away 1000 lines of code."
>   - Ken Thompson.
> 
