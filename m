Return-Path: <linux-kernel-owner+w=401wt.eu-S1765611AbXG0QAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765611AbXG0QAq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 12:00:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762270AbXG0QAg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 12:00:36 -0400
Received: from khc.piap.pl ([195.187.100.11]:42532 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761723AbXG0QAf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 12:00:35 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Josh Triplett <josht@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-sparse@vger.kernel.org
Subject: Re: [PATCH] CodingStyle: proscribe do-while without braces.
References: <1185485822.4459.1.camel@josh-work.beaverton.ibm.com>
	<m3abtir95x.fsf@maximus.localdomain>
	<20070726173501.9ba466ba.akpm@linux-foundation.org>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Fri, 27 Jul 2007 18:00:33 +0200
In-Reply-To: <20070726173501.9ba466ba.akpm@linux-foundation.org> (Andrew Morton's message of "Thu, 26 Jul 2007 17:35:01 -0700")
Message-ID: <m3bqdx6dlq.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> it's better that we all do things the same way.  What that way _is_ is
> actually less important, unless it's something stupid, of course.

It's certainly true WRT things like indentation but IMHO it shouldn't
go that far, and if it goes, it should be non-braced version.

If we prefer non-braced versions of "if" and "while", it would be
a bit strange to require braces with "do while", wouldn't it?

Sparse warnings... I think it shouldn't complain either, unless
called with extra parameter.


Perhaps some pointer to a bad-looking example so I can see for myself?
-- 
Krzysztof Halasa
