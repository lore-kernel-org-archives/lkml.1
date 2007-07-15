Return-Path: <linux-kernel-owner+w=401wt.eu-S1762676AbXGOQ4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762676AbXGOQ4R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 12:56:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759419AbXGOQ4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 12:56:08 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:58126 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757397AbXGOQ4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 12:56:07 -0400
Date: Mon, 16 Jul 2007 01:46:42 +0900 (JST)
Message-Id: <20070716.014642.41651135.tshibata@ab.jp.nec.com>
To: rob@landley.net
Cc: LeoLi@freescale.com, gh@us.ibm.com, hpa@zytor.com,
       kunai@linux-foundation.jp, holzheu@linux.vnet.ibm.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       lf_kernel_messages@linux-foundation.org, tshibata@ab.jp.nec.com
Subject: Re: Documentation of kernel messages (Summary)
From: Tsugikazu Shibata <tshibata@ab.jp.nec.com>
In-Reply-To: <200707142212.35874.rob@landley.net>
References: <200707131312.28004.rob@landley.net>
	<20070714.104659.74729155.tshibata@ab.jp.nec.com>
	<200707142212.35874.rob@landley.net>
X-Mailer: Mew version 4.2 on Emacs 20.7 / Mule 4.1
 =?iso-2022-jp?B?KBskQjAqGyhCKQ==?=
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Jul 2007 22:12:35 -0400, rob wrote:
> On Friday 13 July 2007 9:46:59 pm Tsugikazu Shibata wrote:
> > > > How about adding;
> > > > kernel-doc-nano-HOWTO.txt
> > >
> > > The problem is, the generated htmdocs are in english.  This file is about
> > > how to generate (and author) English documentation that won't be
> > > translated. What's the point of translating the instructions if the
> > > result won't be translated?
> >
> > People (who even in non-native) would better to know and read it such
> > htmldocs because there are good and important documents even in English.
> > I thought that translation of this file may help.
> 
> The english version of htmldocs is generated from the source code.    If 
> translating remotely current versions of htmldocs into other languages was 
> feasible, then the english version wouldn't need to be in the source code in 
> the first place.
> 
> Translating a document _about_ htmldocs boils down to "Dear non-english 
> speaker: here's something you can't read, nor can you update it either except 
> though your language maintainer."

No, kernel-doc-nano-HOWTO includes explanation of tools to extract the
document, format of extractable document in source files and so on.
I thought this file would help non-native people, how to extract or add
in-kernel extractable documents.
I understand that these tools will generate English documents but
that's OK. Such large volume of documents are not easy to translate
into other languages.

> 
> Rob
> -- 
> "One of my most productive days was throwing away 1000 lines of code."
>   - Ken Thompson.
> 
