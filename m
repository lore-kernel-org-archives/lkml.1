Return-Path: <linux-kernel-owner+w=401wt.eu-S1760162AbXGMQGh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760162AbXGMQGh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 12:06:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758917AbXGMQG0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 12:06:26 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:47500
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758783AbXGMQGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 12:06:25 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] Chinese Language Maintainer
Date: Fri, 13 Jul 2007 12:06:16 -0400
User-Agent: KMail/1.9.6
Cc: Li Yang-r58472 <LeoLi@freescale.com>, Gerrit Huizenga <gh@us.ibm.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Kunai, Takashi" <kunai@linux-foundation.jp>,
       holzheu@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, lf_kernel_messages@linux-foundation.org,
       mtk-manpages@gmx.net, jack@suse.cz, randy.dunlap@oracle.com,
       gregkh@suse.de, tim.bird@am.sony.com, arjan@infradead.org,
       sam@ravnborg.org, jengelh@computergmbh.de, joe@perches.com,
       auke-jan.h.kok@intel.com, hansendc@us.ibm.com, davem@davemloft.net,
       Valdis.Kletnieks@vt.edu, kenistoj@us.ibm.com, schwidefsky@de.ibm.com,
       heiko.carstens@de.ibm.com, linux-doc@vger.kernel.org
References: <989B956029373F45A0B8AF0297081890F05F2F@zch01exm26.fsl.freescale.net> <200707121205.20959.rob@landley.net> <20070712200247.GA6001@ucw.cz>
In-Reply-To: <20070712200247.GA6001@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707131206.17297.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 July 2007 4:02:47 pm Pavel Machek wrote:
> Hi!
>
> > @@ -0,0 +1,20 @@
> > +The langauges in which the Linux kernel is developed are C and English.
> > +(Note that Linus Torvalds' native language is Swedish, yet he chose
>
> choose?

I was trying for past tense.

> > +A language maintainer accepts patches to the Linux kernel, written in C,
> > from +authors who do not also speak English.  The language maintainer
> > translates the +description of each patch into English, forwards the
> > patches to linux-kernel +and to the appropriate maintainers for inclusion
> > in the Linux kernel, and +translates questions and replies about such
> > patches as part of the +patch review process.
>
> Poor person... I'm not sure this can work for non-trivial patches.

We'll see.  Personally, I'm more worried about how people who don't speak 
english are supposed to choose function and variable names.  But translating 
_just_ the patch is not the end of it, and I wanted to make that clear.

I suppose a translator can always push back and ask for a _concise_ review, 
for the sake of translation.  But let's not invent problems before they 
actually occur...

> 							Pavel

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
