Return-Path: <linux-kernel-owner+w=401wt.eu-S1752331AbXLYDdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752331AbXLYDdT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2007 22:33:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751132AbXLYDdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Dec 2007 22:33:10 -0500
Received: from one.firstfloor.org ([213.235.205.2]:33715 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070AbXLYDdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2007 22:33:09 -0500
Date: Tue, 25 Dec 2007 04:34:18 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Theodore Tso <tytso@mit.edu>, Christoph Lameter <clameter@sgi.com>,
       Andi Kleen <andi@firstfloor.org>, Willy Tarreau <w@1wt.eu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Major regression on hackbench with SLUB (more numbers)
Message-ID: <20071225033418.GA29199@one.firstfloor.org>
References: <alpine.LFD.0.9999.0712220937560.21557@woody.linux-foundation.org> <20071222192550.GD28891@thunk.org> <alpine.LFD.0.9999.0712221251110.21557@woody.linux-foundation.org> <20071222221050.GA20753@1wt.eu> <Pine.LNX.4.58.0712221954530.19187@gandalf.stny.rr.com> <20071223051241.GA4449@1wt.eu> <20071223141500.GB6430@one.firstfloor.org> <20071224034530.GB16658@thunk.org> <Pine.LNX.4.64.0712241120230.8849@schroedinger.engr.sgi.com> <20071224233701.GB9784@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071224233701.GB9784@kernel.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> And is /sys/slab
> guaranteed to be a stable and permanent interface if the SLAB

Debugging feature and "stable and permanent" just don't 
fit together. It's like requesting stable and permanent
sysrq output.

-Andi
