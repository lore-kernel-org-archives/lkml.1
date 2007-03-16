Return-Path: <linux-kernel-owner+w=401wt.eu-S965974AbXCPVxH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965974AbXCPVxH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 17:53:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965976AbXCPVxH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 17:53:07 -0400
Received: from smtp.osdl.org ([65.172.181.24]:37686 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965970AbXCPVxF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 17:53:05 -0400
Date: Fri, 16 Mar 2007 14:51:47 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
cc: Martin Bligh <mbligh@mbligh.org>, Andi Kleen <andi@firstfloor.org>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Andy Whitcroft <apw@shadowen.org>
Subject: Re: [PATCH 00/18] Make common x86 arch area for i386 and x86_64 -
 Take 2
In-Reply-To: <Pine.LNX.4.64.0703161401270.6204@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0703161450110.3816@woody.linux-foundation.org>
References: <20070314050819.536207642@goodmis.org> <p73slc8863r.fsf@bingen.suse.de>
 <20070314125330.GA13168@elte.hu> <Pine.LNX.4.64.0703140850250.9690@woody.linux-foundation.org>
 <45F96B57.10206@mbligh.org> <Pine.LNX.4.64.0703150858040.3816@woody.linux-foundation.org>
 <20070315160648.GA11812@one.firstfloor.org> <1173977264.7922.24.camel@localhost.localdomain>
 <Pine.LNX.4.64.0703152123480.29284@schroedinger.engr.sgi.com>
 <20070316114415.GA26403@one.firstfloor.org> <Pine.LNX.4.64.0703161313240.6204@schroedinger.engr.sgi.com>
 <45FAFD57.90601@mbligh.org> <Pine.LNX.4.64.0703161346060.6204@schroedinger.engr.sgi.com>
 <45FB0548.5070909@mbligh.org> <Pine.LNX.4.64.0703161401270.6204@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 16 Mar 2007, Christoph Lameter wrote:
> 
> Yes he has already explained it and I am well aware of the difficulties 
> on 32 bit. -> linux-mm archives.

Stop pointing to archives.

If you cannot give a http pointer to a specific thread, don't bother with 
the "please real the list" thing AT ALL.

And I'm sorry, "we decided this on linux-mm" doesn't cut it as an 
explanation _or_ as a "it's already been decided". Many relevant people 
simply aren't on that mailing list.

		Linus
