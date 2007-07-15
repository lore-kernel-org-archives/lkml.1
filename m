Return-Path: <linux-kernel-owner+w=401wt.eu-S1760392AbXGOCMq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760392AbXGOCMq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 22:12:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751020AbXGOCMk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 22:12:40 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:43174
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750763AbXGOCMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 22:12:39 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Tsugikazu Shibata <tshibata@ab.jp.nec.com>
Subject: Re: Documentation of kernel messages (Summary)
Date: Sat, 14 Jul 2007 22:12:35 -0400
User-Agent: KMail/1.9.6
Cc: LeoLi@freescale.com, gh@us.ibm.com, hpa@zytor.com,
       kunai@linux-foundation.jp, holzheu@linux.vnet.ibm.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       lf_kernel_messages@linux-foundation.org
References: <200707121335.55817.rob@landley.net> <200707131312.28004.rob@landley.net> <20070714.104659.74729155.tshibata@ab.jp.nec.com>
In-Reply-To: <20070714.104659.74729155.tshibata@ab.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707142212.35874.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 13 July 2007 9:46:59 pm Tsugikazu Shibata wrote:
> > > How about adding;
> > > kernel-doc-nano-HOWTO.txt
> >
> > The problem is, the generated htmdocs are in english.  This file is about
> > how to generate (and author) English documentation that won't be
> > translated. What's the point of translating the instructions if the
> > result won't be translated?
>
> People (who even in non-native) would better to know and read it such
> htmldocs because there are good and important documents even in English.
> I thought that translation of this file may help.

The english version of htmldocs is generated from the source code.    If 
translating remotely current versions of htmldocs into other languages was 
feasible, then the english version wouldn't need to be in the source code in 
the first place.

Translating a document _about_ htmldocs boils down to "Dear non-english 
speaker: here's something you can't read, nor can you update it either except 
though your language maintainer."

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
