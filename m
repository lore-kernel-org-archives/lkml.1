Return-Path: <linux-kernel-owner+w=401wt.eu-S932776AbXIKTfn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932776AbXIKTfn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 15:35:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753492AbXIKTfc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 15:35:32 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:53192 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752482AbXIKTfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 15:35:30 -0400
Date: Tue, 11 Sep 2007 12:35:18 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Chris Snook <csnook@redhat.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Nick Piggin <piggin@cyberone.com.au>,
       Satyam Sharma <satyam@infradead.org>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Paul Mackerras <paulus@samba.org>,
       Ilpo Jarvinen <ilpo.jarvinen@helsinki.fi>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, ak@suse.de,
       heiko.carstens@de.ibm.com, David Miller <davem@davemloft.net>,
       schwidefsky@de.ibm.com, wensong@linux-vs.org, horms@verge.net.au,
       wjiang@resilience.com, cfriesen@nortel.com, zlynx@acm.org,
       rpjday@mindspring.com, jesper.juhl@gmail.com,
       segher@kernel.crashing.org
Subject: Re: [PATCH] Document non-semantics of atomic_read() and atomic_set()
In-Reply-To: <20070910231944.GA3484@shell.boston.redhat.com>
Message-ID: <Pine.LNX.4.64.0709111235030.25610@schroedinger.engr.sgi.com>
References: <18115.52863.638655.658466@cargo.ozlabs.ibm.com>
 <6370BBDF-0C79-41EB-BD2A-02AA0D216924@mac.com> <200709101438.36710.vda.linux@googlemail.com>
 <200709101516.03234.vda.linux@googlemail.com>
 <alpine.LFD.0.999.0709100807260.16478@woody.linux-foundation.org>
 <20070910231944.GA3484@shell.boston.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Christoph Lameter <clameter@sgi.com>

