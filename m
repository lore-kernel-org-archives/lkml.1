Return-Path: <linux-kernel-owner+w=401wt.eu-S1764255AbXGYWXN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764255AbXGYWXN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 18:23:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753719AbXGYWW6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 18:22:58 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:53569
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750822AbXGYWW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 18:22:57 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 1/7] lguest: documentation pt I: Preparation
Date: Wed, 25 Jul 2007 18:22:54 -0400
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>,
       "Randy.Dunlap" <rdunlap@xenotime.net>
References: <1184980678.6344.1.camel@localhost.localdomain> <20070723171238.1a832b31.akpm@linux-foundation.org> <1185238908.1803.63.camel@localhost.localdomain>
In-Reply-To: <1185238908.1803.63.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707251822.54745.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 July 2007 9:01:48 pm Rusty Russell wrote:
> > IOW, I'd be interested in hearing Rob and Randy's opinions on it all,
> > please.
>
> So they can see what we're talking about, here's an example of the
> output:
>
> 	http://lguest.ozlabs.org/lguest-journey.c.bz2

Er, so you read the readme, and then you type "make Preparation!" (which I 
wouldn't have guessed from the comment at the end of the readme), and it 
spits this to stdout.  Ok, I can add "make 'Preparation!' > lguest.txt" to my 
update script so I can mirror a copy of the output on the web.

Are there any other build targets that produce documentation which I should 
know about?

> Cheers,
> Rusty.

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
