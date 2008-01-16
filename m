Return-Path: <linux-kernel-owner+w=401wt.eu-S1755122AbYAPOfL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755122AbYAPOfL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 09:35:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753717AbYAPOe7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 09:34:59 -0500
Received: from tomts20.bellnexxia.net ([209.226.175.74]:54356 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752703AbYAPOe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 09:34:58 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aj0KACKljUdMROHU/2dsb2JhbACBWKxU
Date: Wed, 16 Jan 2008 09:34:46 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>, ananth@in.ibm.com,
       dhowells@redhat.com, jdike@addtoit.com, sam@ravnborg.org,
       Adrian Bunk <adrian.bunk@movial.fi>,
       Randy Dunlap <randy.dunlap@oracle.com>, phil.el@wanadoo.fr,
       oprofile-list@lists.sourceforge.net
Subject: Re: [PATCH for -mm] Fix ARM to play nicely with generic
	Instrumentation menu
Message-ID: <20080116143446.GA31329@Krystal>
References: <20080116025341.GA31346@Krystal> <20080116085155.GA11617@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080116085155.GA11617@flint.arm.linux.org.uk>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:27:33 up 73 days, 19:33,  3 users,  load average: 1.21, 0.92,
	0.62
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Russell King (rmk+lkml@arm.linux.org.uk) wrote:
> On Tue, Jan 15, 2008 at 09:53:41PM -0500, Mathieu Desnoyers wrote:
> > This patch cleans up the fix from Linus so it does not conflict with the
> > following patches in -mm.
> 
> What following patches?
> 

Instrumentation menu removal, which was in -mm until yesterday.

http://lkml.org/lkml/2007/12/8/81

I did this patch following a discussion with Linus about a month ago
where I was proposing the creation of the instrumentation/ directory in
the kernel sources to follow the menus/tree directories logic found in
the rest of the kernel.

http://lkml.org/lkml/2007/10/30/318

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
