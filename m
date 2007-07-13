Return-Path: <linux-kernel-owner+w=401wt.eu-S1760725AbXGMRw3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760725AbXGMRw3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 13:52:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756320AbXGMRwS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 13:52:18 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:54168
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755383AbXGMRwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 13:52:17 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: leoli@freescale.com
Subject: Re: [PATCH] Chinese Language Maintainer
Date: Fri, 13 Jul 2007 13:52:11 -0400
User-Agent: KMail/1.9.6
Cc: Gerrit Huizenga <gh@us.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>,
       "Kunai, Takashi" <kunai@linux-foundation.jp>,
       holzheu@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, lf_kernel_messages@linux-foundation.org,
       mtk-manpages@gmx.net, jack@suse.cz, randy.dunlap@oracle.com,
       gregkh@suse.de, pavel@ucw.cz, tim.bird@am.sony.com, arjan@infradead.org,
       sam@ravnborg.org, jengelh@computergmbh.de, joe@perches.com,
       auke-jan.h.kok@intel.com, hansendc@us.ibm.com, davem@davemloft.net,
       Valdis.Kletnieks@vt.edu, kenistoj@us.ibm.com, schwidefsky@de.ibm.com,
       heiko.carstens@de.ibm.com, linux-doc@vger.kernel.org
References: <989B956029373F45A0B8AF0297081890F05F2F@zch01exm26.fsl.freescale.net> <200707121205.20959.rob@landley.net> <1184330583.23373.65.camel@Gundam>
In-Reply-To: <1184330583.23373.65.camel@Gundam>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707131352.12952.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 13 July 2007 8:43:03 am Li Yang wrote:
> On Thu, 2007-07-12 at 12:05 -0400, Rob Landley wrote:
> > Proposed patch adding Li Yang to MAINTAINERS, and Documentation
> > describing what a language maintainer is.
> >
> > Signed-off-by: Rob Landley <rob@landley.net>
>
> Signed-off-by: Li Yang <leo@zh-kernel.org>

Yay!

> > +A language maintainer accepts patches to the Linux kernel, written in C,
> > from +authors who do not also speak English.  The language maintainer
> > translates the +description of each patch into English, forwards the
> > patches to linux-kernel +and to the appropriate maintainers for inclusion
> > in the Linux kernel, and +translates questions and replies about such
> > patches as part of the +patch review process.
>
> In addiction to this responsibility, I would like to add two more which,
> in my opinion, are more important.  And these are what I'm trying to
> do.  :)
> First, promoting contribution to Linux kernel in local language.
> Second, coordinate the translation effort of key kernel documents.

Cool.  It's good to do that, but not the problem I'm worried about solving.

I was trying to describe the minimum requirements for being a language 
maintainer, I.E. what non-english users need in order to be able to merge 
their patches.  Because without someone to contribute patches to (I.E a 
language maintainer), documentation in non-english languages promotes the 
creation of patches that can't be merged.  That's the problem I'm trying to 
solve.

To me, finding language maintainers is the flip side of the coin of 
translating documentation.

Rob

-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
