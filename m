Return-Path: <linux-kernel-owner+w=401wt.eu-S933019AbYEBO7I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933019AbYEBO7I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 10:59:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758153AbYEBO64
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 10:58:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42874 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752896AbYEBO6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 10:58:55 -0400
Date: Fri, 2 May 2008 07:58:25 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Adrian Bunk <bunk@kernel.org>
cc: Paul Mackerras <paulus@samba.org>, Josh Boyer <jwboyer@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, davem@davemloft.net,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: RFC: starting a kernel-testers group for newbies
In-Reply-To: <20080502082936.GB2003@cs181133002.pp.htv.fi>
Message-ID: <alpine.LFD.1.10.0805020750220.5994@woody.linux-foundation.org>
References: <20080430131537.1f7a0914.akpm@linux-foundation.org> <alpine.LFD.1.10.0804301325260.2980@woody.linux-foundation.org> <20080501003125.GM29330@cs181133002.pp.htv.fi> <20080430000338.50548884@infradead.org> <20080501113038.GW29330@cs181133002.pp.htv.fi>
 <20080430072013.7c3b30b1@infradead.org> <20080501132159.GC29330@cs181133002.pp.htv.fi> <18458.30641.838156.434563@cargo.ozlabs.ibm.com> <1209697815.2946.156.camel@vader.jdub.homelinux.org> <18458.37891.268060.691285@cargo.ozlabs.ibm.com>
 <20080502082936.GB2003@cs181133002.pp.htv.fi>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 2 May 2008, Adrian Bunk wrote:
> 
> But for users this is a recent regression since 2.6.24 worked
> and 2.6.25 does not.

Totally and utterly immaterial.

If it's a timing-related bug, as far as developers are concerned, nothing 
they did introduced the problem.

So anybody who think s that "process" should have caught it is just being 
stupid. 

Adrian, you're one of the absolutely *worst* in the camp of "everything 
should be perfect". You really need to realize that reality is messy, and 
things cannot be pefect.

You also need to realize and *understand* that aiming for "good" is 
actually much BETTER than trying to aim for "perfect".

Perfect is the enemy of good.

			Linus
