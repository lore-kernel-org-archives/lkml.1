Return-Path: <linux-kernel-owner+w=401wt.eu-S1755445AbXGIQsm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445AbXGIQsm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 12:48:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751691AbXGIQse
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 12:48:34 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:49524
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751183AbXGIQsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 12:48:33 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Documentation of kernel messages (Summary)
Date: Mon, 9 Jul 2007 12:48:24 -0400
User-Agent: KMail/1.9.6
Cc: "Kunai, Takashi" <kunai@linux-foundation.jp>, holzheu@linux.vnet.ibm.com,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       lf_kernel_messages@linux-foundation.org, mtk-manpages@gmx.net,
       jack@suse.cz, randy.dunlap@oracle.com, gregkh@suse.de, pavel@ucw.cz,
       tim.bird@am.sony.com, gh@us.ibm.com, arjan@infradead.org,
       sam@ravnborg.org, jengelh@computergmbh.de, joe@perches.com,
       auke-jan.h.kok@intel.com, hansendc@us.ibm.com, davem@davemloft.net,
       Valdis.Kletnieks@vt.edu, kenistoj@us.ibm.com, schwidefsky@de.ibm.com,
       heiko.carstens@de.ibm.com, linux-doc@vger.kernel.org
References: <1181747217.29512.9.camel@localhost.localdomain> <4691C480.5010600@linux-foundation.jp> <4691C95F.7080502@zytor.com>
In-Reply-To: <4691C95F.7080502@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707091248.24994.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In regard to translating kernel messages:

On Monday 09 July 2007 01:36:31 H. Peter Anvin wrote:
> Kunai, Takashi wrote:
> > (1) Your kernel development proposal will be greatly supported by
> > Japanese vendor community. At the same time, it needs support from the
> > kernel communities, as well.
>
> There is a very strong reason for the kernel community to NOT support
> this: it makes it much harder to deal with bug reports.

Agreed.

There's a proposal in play for translations of documentation, and to 
recruit "language maintainers" (which is an idea I see that Matt Mackall came 
up with before I did).

A language maintainer is somebody who can accept a patch in language X, 
translate its description to post on the appropriate english-only list with a 
cc: to the appropriate maintainer(s), and translate questions and reviews 
back and forth for the original author until the patch can be merged.  (This 
means that documentation translations don't result in a stream of unmergeable 
patches.)

As for the documentation translations themselves, I note that Eric Raymond 
dissuaded me from actually hosting translations of kernel documentation on 
http://kernel.org/doc due to his experience with translations of his own 
writings.  If he hosts the translations on his website, they never get 
updated again.  But if he makes the contributor host them on their own 
website, then they sometimes get updated.

For my part, I can't _tell_ when a given translation is out of date because I 
can't read it, and I certainly can't update it.  So I agree with Eric and I'm 
linking to sites hosting kernel documentation in other languages rather than 
hosting them myself.  I've got a good link to a Japanese site, need to ping 
the contributors of the chinese documentation and see if they have a site for 
it...

I await hearing back from Satoru Ueda who might have a lead on a potential 
Japanese maintainer, probably after some event in Japan (a "Jamboree") in a 
week or two...

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
