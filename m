Return-Path: <linux-kernel-owner+w=401wt.eu-S1754776AbXLVMyL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776AbXLVMyL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 07:54:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751558AbXLVMx6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 07:53:58 -0500
Received: from one.firstfloor.org ([213.235.205.2]:51056 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936AbXLVMx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 07:53:57 -0500
Date: Sat, 22 Dec 2007 13:54:54 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Christoph Lameter <clameter@sgi.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Major regression on hackbench with SLUB (more numbers)
Message-ID: <20071222125454.GD14767@one.firstfloor.org>
References: <alpine.LFD.0.9999.0712210835440.21557@woody.linux-foundation.org> <Pine.LNX.4.64.0712211356220.3795@schroedinger.engr.sgi.com> <1198275391.30889.3.camel@lappy> <1198275453.30889.4.camel@lappy> <Pine.LNX.4.64.0712211422540.3795@schroedinger.engr.sgi.com> <20071221225413.GA26189@elte.hu> <p731w9ffu8c.fsf@bingen.suse.de> <20071222100326.GF26157@elte.hu> <20071222123705.GA14767@one.firstfloor.org> <84144f020712220451s87a3957i1f1c64a60c6a8473@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020712220451s87a3957i1f1c64a60c6a8473@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yeah but then again removing an interface that has been around for
> ever 

Version 2.1 hasn't been around forever and at least slabtop does not
work over version number changes in my experience.

-Andi
