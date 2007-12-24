Return-Path: <linux-kernel-owner+w=401wt.eu-S1752947AbXLXTZG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752947AbXLXTZG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2007 14:25:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751082AbXLXTY4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Dec 2007 14:24:56 -0500
Received: from relay2.sgi.com ([192.48.171.30]:60165 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751088AbXLXTY4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2007 14:24:56 -0500
Date: Mon, 24 Dec 2007 11:24:55 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Ingo Molnar <mingo@elte.hu>
cc: David Miller <davem@davemloft.net>, a.p.zijlstra@chello.nl,
       torvalds@linux-foundation.org, rostedt@goodmis.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       hch@infradead.org, rjw@sisk.pl
Subject: Re: Major regression on hackbench with SLUB (more numbers)
In-Reply-To: <20071222094459.GE26157@elte.hu>
Message-ID: <Pine.LNX.4.64.0712241122010.8849@schroedinger.engr.sgi.com>
References: <1198275453.30889.4.camel@lappy> <Pine.LNX.4.64.0712211422540.3795@schroedinger.engr.sgi.com>
 <20071221225413.GA26189@elte.hu> <20071221.152008.11508772.davem@davemloft.net>
 <20071222094459.GE26157@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Dec 2007, Ingo Molnar wrote:

> Christoph, i'd like to apologize for all overly harsh words i said. (and 
> i said quite a few :-/ )

Looks like a bad interaction due to overload, vacation, flu epidemic 
hitting me and family and also Christmas coming up so that I could not do 
my usual workload. Need to find some way to cut back on the stuff that I 
am involved with it seems. Thanks for the SLUB patches.

