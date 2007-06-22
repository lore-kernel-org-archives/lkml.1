Return-Path: <linux-kernel-owner+w=401wt.eu-S1756227AbXFVVAS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756227AbXFVVAS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 17:00:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752126AbXFVVAH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 17:00:07 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:43552
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440AbXFVVAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 17:00:06 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: TripleX <zhongyu@18mail.cn>
Subject: Re: [PATCH] Chinese translation of Documentation/HOWTO
Date: Fri, 22 Jun 2007 17:00:09 -0400
User-Agent: KMail/1.9.6
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Li Yang-r58472 <LeoLi@freescale.com>, gregkh@suse.de,
       linux-kernel@vger.kernel.org, xiyou.wangcong@gmail.com,
       bryan.wu@analog.com, TripleX Chung <xxx.phy@gmail.com>,
       Maggie Chen <chenqi@beyondsoft.com>
References: <989B956029373F45A0B8AF0297081890D83001@zch01exm26.fsl.freescal e.net> <alpine.LFD.0.98.0706220950110.3593@woody.linux-foundation.org> <467C1768.1030706@18mail.cn>
In-Reply-To: <467C1768.1030706@18mail.cn>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706221700.13793.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 22 June 2007 14:39:36 TripleX wrote:
> As I know, there are a lot of standalone kernel developer in China. They
> write device drivers for their chips or iptables modules for their
> linux based network devices. They send source files to their customers
> or publish them on web but seldom do anything to make the codes into
> kernel source tree. The usual reason  is they do not know how to
> communicate and work with the Linux kernel development community. People
> will have more chance to read these documentation  if we merge them to
> the kernel source tree.

There are two distinct problems here:

1) Documentation so developers who know C but not English have an easier time 
working with the kernel.  (Again, if you translate it, send it to me and I'll 
put it on the web.  After OLS, though. :)

2) Some kind of "language X patch maintainer", a bilingual person who can 
accept patches from people who don't speak English, submit them to the 
mailing list, and pass comments back and forth until issues with the patch 
are resolved.  So there could be a chinese patch maintainer, a spanish patch 
maintainer, etc.

> TripleX

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
