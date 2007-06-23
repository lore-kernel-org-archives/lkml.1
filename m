Return-Path: <linux-kernel-owner+w=401wt.eu-S1754009AbXFWWLA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009AbXFWWLA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 18:11:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752575AbXFWWKx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 18:10:53 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55082 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751926AbXFWWKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 18:10:53 -0400
Date: Sat, 23 Jun 2007 15:09:03 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, tglx@linutronix.de, hch@infradead.org,
       johnstul@us.ibm.com, oleg@tv-sign.ru, paulmck@linux.vnet.ibm.com,
       dipankar@in.ibm.com, davem@davemloft.net, kuznet@ms2.inr.ac.ru
Subject: Re: [RFC PATCH 5/5 v2] Convert tasklets to work queues
In-Reply-To: <1182626869.5493.143.camel@localhost.localdomain>
Message-ID: <alpine.LFD.0.98.0706231508420.3593@woody.linux-foundation.org>
References: <20070622182051.859570787@goodmis.org>  <20070622182315.571740041@goodmis.org>
  <20070623095359.4667514e.akpm@linux-foundation.org> 
 <alpine.LFD.0.98.0706231113200.3593@woody.linux-foundation.org>
 <1182626869.5493.143.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 23 Jun 2007, Steven Rostedt wrote:
> > 
> > On Sat, 23 Jun 2007, Andrew Morton wrote:
> > > 
> > > Anyway.  Please fix the many correct warnings which checkpatch.pl
> > > generates
> > 
> > Actually, please don't.
> 
> You sure?  If I were to do this recommended fix, I would simply add
> another patch. One to do the fixes, the other to move the code.

Sure, that sounds fine.

		Linus
