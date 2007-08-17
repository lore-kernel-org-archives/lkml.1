Return-Path: <linux-kernel-owner+w=401wt.eu-S1758145AbXHQWkb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758145AbXHQWkb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 18:40:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752994AbXHQWkO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 18:40:14 -0400
Received: from gate.crashing.org ([63.228.1.57]:35515 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752062AbXHQWkM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 18:40:12 -0400
In-Reply-To: <alpine.LFD.0.999.0708170945300.3666@enigma.security.iitk.ac.in>
References: <20070809131423.GA9927@shell.boston.redhat.com> <Pine.LNX.4.64.0708141529310.32693@schroedinger.engr.sgi.com> <alpine.LFD.0.999.0708150417240.6482@enigma.security.iitk.ac.in> <46C2D6F3.3070707@s5r6.in-berlin.de> <alpine.LFD.0.999.0708151713080.16414@enigma.security.iitk.ac.in> <20070815233721.91032366.billfink@mindspring.com> <alpine.LFD.0.999.0708161045360.25951@enigma.security.iitk.ac.in> <4952d3f536060c186f40c277dfc74194@kernel.crashing.org> <alpine.LFD.0.999.0708170945300.3666@enigma.security.iitk.ac.in>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <33a54cfcfda7e50e43a7399780626869@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: Christoph Lameter <clameter@sgi.com>, heiko.carstens@de.ibm.com,
       horms@verge.net.au, Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Bill Fink <billfink@mindspring.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, netdev@vger.kernel.org,
       ak@suse.de, cfriesen@nortel.com, rpjday@mindspring.com,
       jesper.juhl@gmail.com, linux-arch@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, zlynx@acm.org,
       davids@webmaster.com, schwidefsky@de.ibm.com,
       Chris Snook <csnook@redhat.com>,
       Herbert Xu <herbert@gondor.apana.org.au>, davem@davemloft.net,
       Linus Torvalds <torvalds@linux-foundation.org>, wensong@linux-vs.org,
       wjiang@resilience.com
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [PATCH 0/24] make atomic_read() behave consistently across all architectures
Date: Sat, 18 Aug 2007 00:34:34 +0200
To: Satyam Sharma <satyam@infradead.org>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Now the second wording *IS* technically correct, but come on, it's
> 24 words long whereas the original one was 3 -- and hopefully anybody
> reading the shorter phrase *would* have known anyway what was meant,
> without having to be pedantic about it :-)

Well you were talking pretty formal (and detailed) stuff, so
IMHO it's good to have that exactly correct.  Sure it's nicer
to use small words most of the time :-)


Segher

