Return-Path: <linux-kernel-owner+w=401wt.eu-S1755549AbZBOSa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549AbZBOSa2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 13:30:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753932AbZBOSaR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 13:30:17 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:57299 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753857AbZBOSaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 13:30:16 -0500
Subject: Re: git-send-email
From: Peter Zijlstra <peterz@infradead.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Junio C Hamano <junio@pobox.com>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Ingo Oeser <ioe-lkml@rameria.de>, L-K <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <49984ED4.4000306@s5r6.in-berlin.de>
References: <1234451714.10603.22.camel@laptop>
	 <20090212192104.GD15809@csclub.uwaterloo.ca>
	 <1234477025.10603.38.camel@laptop> <200902131034.05814.ioe-lkml@rameria.de>
	 <20090213163923.GE15809@csclub.uwaterloo.ca>
	 <7vtz6y6kjt.fsf@gitster.siamese.dyndns.org>
	 <49984ED4.4000306@s5r6.in-berlin.de>
Content-Type: text/plain
Date: Sun, 15 Feb 2009 19:30:05 +0100
Message-Id: <1234722605.4713.192.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-02-15 at 18:20 +0100, Stefan Richter wrote:
> Junio C Hamano wrote:
> > Just like the kernel folks take regressions seriously to the point to say
> > breaking one person's working setup is worse than fixing a known bug that
> > affects many more people,
> 
> BTW, from the manual:
> 
>        --chain-reply-to, --no-chain-reply-to
>            [...] Default is the value of the sendemail.chainreplyto
>            configuration value; if that is unspecified, default to
>            --chain-reply-to.
> 
> Everybody who isn't afraid of configuration files can implement his
> preferred default easily.

Yep, trouble is with all those folks who

 1) don't know about the option
 2) aren't educated to know its a good idea to use it

So by changing the default we're better off all around.

