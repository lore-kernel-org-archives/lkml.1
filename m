Return-Path: <linux-kernel-owner+w=401wt.eu-S934714AbXGQQHQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934714AbXGQQHQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 12:07:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757709AbXGQQHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 12:07:04 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:48525
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757908AbXGQQHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 12:07:01 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Tsugikazu Shibata <tshibata@ab.jp.nec.com>
Subject: Re: Documentation of kernel messages (Summary)
Date: Tue, 17 Jul 2007 12:06:56 -0400
User-Agent: KMail/1.9.6
Cc: LeoLi@freescale.com, gh@us.ibm.com, hpa@zytor.com,
       kunai@linux-foundation.jp, holzheu@linux.vnet.ibm.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       lf_kernel_messages@linux-foundation.org
References: <200707131312.28004.rob@landley.net> <200707142212.35874.rob@landley.net> <20070716.014642.41651135.tshibata@ab.jp.nec.com>
In-Reply-To: <20070716.014642.41651135.tshibata@ab.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707171206.56805.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 15 July 2007 12:46:42 pm Tsugikazu Shibata wrote:
> On Sat, 14 Jul 2007 22:12:35 -0400, rob wrote:
> > On Friday 13 July 2007 9:46:59 pm Tsugikazu Shibata wrote:
> > > > > How about adding;
> > > > > kernel-doc-nano-HOWTO.txt
> > > >
> > > > The problem is, the generated htmdocs are in english.  This file is
> > > > about how to generate (and author) English documentation that won't
> > > > be translated. What's the point of translating the instructions if
> > > > the result won't be translated?
> > >
> > > People (who even in non-native) would better to know and read it such
> > > htmldocs because there are good and important documents even in
> > > English. I thought that translation of this file may help.
> >
> > The english version of htmldocs is generated from the source code.    If
> > translating remotely current versions of htmldocs into other languages
> > was feasible, then the english version wouldn't need to be in the source
> > code in the first place.
> >
> > Translating a document _about_ htmldocs boils down to "Dear non-english
> > speaker: here's something you can't read, nor can you update it either
> > except though your language maintainer."
>
> No, kernel-doc-nano-HOWTO includes explanation of tools to extract the
> document, format of extractable document in source files and so on.
> I thought this file would help non-native people, how to extract or add
> in-kernel extractable documents.

Which will be in english, so why can't the instructions on how to do it be in 
english too?

> I understand that these tools will generate English documents but
> that's OK.

Then the instructions how to do it in english should be ok too.  If they can't 
read the instructions, they won't be able to read the result.

> Such large volume of documents are not easy to translate 
> into other languages.

"Here's how to get a result that will be useless to you."

Why?  What's the point?  I'm not seeing it.

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
