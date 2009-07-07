Return-Path: <linux-kernel-owner+w=401wt.eu-S1756324AbZGGFXA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756324AbZGGFXA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 01:23:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751767AbZGGFWw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 01:22:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:37639 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751455AbZGGFWw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 01:22:52 -0400
Subject: Re: [PATCH -tip V2] x86: thread_info.h moving comment to where it
 should be
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0907062321370.19480@localhost.localdomain>
References: <1246879925.28541.3.camel@hpdv5.satnam>
	 <alpine.LFD.2.00.0907062052230.19480@localhost.localdomain>
	 <1246914309.2478.2.camel@ht.satnam>
	 <alpine.LFD.2.00.0907062321370.19480@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 07 Jul 2009 10:51:28 +0530
Message-Id: <1246944088.2422.10.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-07-07 at 00:44 +0200, Thomas Gleixner wrote:
> Jaswinder,
> 
> On Tue, 7 Jul 2009, Jaswinder Singh Rajput wrote:
> > On Mon, 2009-07-06 at 20:54 +0200, Thomas Gleixner wrote:
> > > On Mon, 6 Jul 2009, Jaswinder Singh Rajput wrote:
> > > > 
> > > > By mistake commit 2052e8d40ad58 moved following comment to wrong place,
> > > > where it does not make any sense :
> > > 
> > > Wrong. commit 2052e8d4 had the comments in the right place. commit
> > > 3351cc03 replaced the two identical INIT_THREAD_INFO macros and did
> > > not update the comments.
> > > 
> > 
> > Ahh so you was also part of it, here is updated patch:
> 
> if you expect that you earn more trust by such snotty comments, then
> you are really on the wrong track. To keep the record straight:
> 

You started it and when it comes to you why you start jumping.

>  _You_ sent a patch with a bogus patch description.
> 

Have you applied it or you only shouts like always.

--
JSR

