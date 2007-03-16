Return-Path: <linux-kernel-owner+w=401wt.eu-S965921AbXCPVCe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965921AbXCPVCe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 17:02:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965928AbXCPVCe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 17:02:34 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:51395 "EHLO
	netops-testserver-4.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965921AbXCPVCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 17:02:33 -0400
Date: Fri, 16 Mar 2007 14:02:32 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Martin Bligh <mbligh@mbligh.org>
cc: Andi Kleen <andi@firstfloor.org>, Steven Rostedt <rostedt@goodmis.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Andy Whitcroft <apw@shadowen.org>
Subject: Re: [PATCH 00/18] Make common x86 arch area for i386 and x86_64 -
 Take 2
In-Reply-To: <45FB0548.5070909@mbligh.org>
Message-ID: <Pine.LNX.4.64.0703161401270.6204@schroedinger.engr.sgi.com>
References: <20070314050819.536207642@goodmis.org> <p73slc8863r.fsf@bingen.suse.de>
 <20070314125330.GA13168@elte.hu> <Pine.LNX.4.64.0703140850250.9690@woody.linux-foundation.org>
 <45F96B57.10206@mbligh.org> <Pine.LNX.4.64.0703150858040.3816@woody.linux-foundation.org>
 <20070315160648.GA11812@one.firstfloor.org> <1173977264.7922.24.camel@localhost.localdomain>
 <Pine.LNX.4.64.0703152123480.29284@schroedinger.engr.sgi.com>
 <20070316114415.GA26403@one.firstfloor.org> <Pine.LNX.4.64.0703161313240.6204@schroedinger.engr.sgi.com>
 <45FAFD57.90601@mbligh.org> <Pine.LNX.4.64.0703161346060.6204@schroedinger.engr.sgi.com>
 <45FB0548.5070909@mbligh.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Mar 2007, Martin Bligh wrote:

> For starters, you can't do that sparse a mapping on a 32 bit system.
> I'll let Andy explain the rest of it.

Yes he has already explained it and I am well aware of the difficulties 
on 32 bit. -> linux-mm archives.

> "the agreement"? So Andy agreed to taking it out? Or you and Kame did?

Yes Andy and lots of others. Big discussion that you seem to want me to 
repeat here.

