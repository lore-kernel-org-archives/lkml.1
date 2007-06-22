Return-Path: <linux-kernel-owner+w=401wt.eu-S1755670AbXFVRDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755670AbXFVRDS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 13:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753737AbXFVRDG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 13:03:06 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44840 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753656AbXFVRDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 13:03:05 -0400
Date: Fri, 22 Jun 2007 10:02:26 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Li Yang-r58472 <LeoLi@freescale.com>
cc: Rob Landley <rob@landley.net>, gregkh@suse.de,
       linux-kernel@vger.kernel.org, xiyou.wangcong@gmail.com,
       bryan.wu@analog.com, TripleX Chung <xxx.phy@gmail.com>,
       Maggie Chen <chenqi@beyondsoft.com>
Subject: RE: [PATCH] Chinese translation of Documentation/HOWTO
In-Reply-To: <989B956029373F45A0B8AF0297081890D83001@zch01exm26.fsl.freescale.net>
Message-ID: <alpine.LFD.0.98.0706220950110.3593@woody.linux-foundation.org>
References: <989B956029373F45A0B8AF0297081890D83001@zch01exm26.fsl.freescal
 e.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 22 Jun 2007, Li Yang-r58472 wrote:
> 
> So as I argued in a previous email, non-native English speakers tend to 
> be more confused by the policies and processes.  I also don't think it's 
> necessary to translate the technical documents.  To be a software 
> developer, one has to be educated or experienced in technical terms. 
> Technical discussion can be done without too much requirement to grammar 
> and emotional expressing.  The translated document of policies and 
> processes will help these people to understand the process better and go 
> smoother in the process.

I do agree.

I think that the policies and processes parts of the documentation are 
things that make total sense to encourage translation of, because it's 
entirely possible that those are interesting and valid even to the people 
who aren't necessarily directly involved in the actual coding, and may 
well be relevant to managers etc who may not be _directly_ involed with 
the rest of the kernel developers.

In fact, I suspect pretty much any documentation (whether technical or 
about processes and/or style) makes sense to have translated if the energy 
and ability to do that exists. I suspect the "policies and processes" 
kinds of docs make _more_ sense to translate initially, simply because 
they are approachable on their own - but I certainly would never 
discourage anybody from translating anything at all.

That said, I don't think that merging the result into the standard kernel 
makes sense - like it or not, right now English ends up being required 
to be part of actually getting things into the "standard" kernel, and as 
such, at _some_ point there has to be a connection point that switches 
over to English, and trying to make the translations be an in-kernel thing 
is thus kind of pointless.

But as part of some "documentation site", it makes 100% sense. 

And sometimes maybe the issue isn't even just about straight translations, 
but also perhaps about explaining cultural differences that aren't 
mentioned at all in the documentation, just because people in the west end 
up taking certain things for granted and it doesn't "need" documenting..

			Linus
