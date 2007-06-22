Return-Path: <linux-kernel-owner+w=401wt.eu-S1753891AbXFVCtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891AbXFVCtV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 22:49:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752032AbXFVCtM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 22:49:12 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:45529
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902AbXFVCtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 22:49:11 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Li Yang <leoli@freescale.com>
Subject: Re: [PATCH] Chinese translation of Documentation/HOWTO
Date: Thu, 21 Jun 2007 22:48:32 -0400
User-Agent: KMail/1.9.6
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, xiyou.wangcong@gmail.com,
       bryan.wu@analog.com, TripleX Chung <xxx.phy@gmail.com>,
       Maggie Chen <chenqi@beyondsoft.com>, torvalds@transmeta.com
References: <1182436817579-git-send-email-leoli@freescale.com>
In-Reply-To: <1182436817579-git-send-email-leoli@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706212248.34128.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 21 June 2007 10:40:17 Li Yang wrote:
> This is a Chinese translated version of Documentation/HOWTO.  Currently
> Chinese involvement in Linux kernel is very low, especially comparing to
> its largest population base.  Language could be the main obstacle.  Hope
> this document will help more Chinese to contribute to Linux kernel.

I'm putting together a kernel documentation directory at http://kernel.org/doc 
and I could easily add translations in there.  I just don't know if this is a 
good idea.

The problem is, the submission of patches happens on the various kernel.org 
mailing lists, which are all in English.  Kernel development is done in a 
single common language: English.  (If you'd like to argue for it to be done 
in another language, please make the proposal in Linus's native Swedish.)

Setting aside for the moment version skew and coverage issues when translating  
Documentation, which aren't really serious blocking issues, my question is 
this:  If developers aren't fluent enough with English to follow the 
documentation, how can they follow any of the technical discussions necessary 
to merge their patches back into the mainstream kernel?  Doesn't this 
encourage the creation of patches that can't easily be merged back into the 
kernel?

It could be that the answer is "no, it's fine".  I don't feel qualified to 
make this decision.  It's very easy for me to accept contributed translations 
and put them up, but I'd like some kind of consensus from the kernel 
developers that I SHOULD do this.  How much use is a Chinese version of a 
HOWTO that tells people how to interact with an English community?

Could somebody more qualified than me speak up on this one so I know what to 
do?

Rob

P.S.  I meant to comment when this topic first came up last week 
[http://kerneltrap.org/node/8365] but my laptop's hard drive died and I lost 
the link.  (Along with any chance of this being a particularly productive 
month for me...)

-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
