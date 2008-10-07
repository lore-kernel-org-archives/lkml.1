Return-Path: <linux-kernel-owner+w=401wt.eu-S1755947AbYJGQik@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755947AbYJGQik (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 12:38:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753664AbYJGQid
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 12:38:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37527 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753477AbYJGQic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 12:38:32 -0400
Date: Tue, 7 Oct 2008 09:37:27 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Matt Mackall <mpm@selenic.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-mm <linux-mm@kvack.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Ingo Molnar <mingo@elte.hu>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] SLOB's krealloc() seems bust
In-Reply-To: <1223395846.26330.55.camel@lappy.programming.kicks-ass.net>
Message-ID: <alpine.LFD.2.00.0810070924130.3208@nehalem.linux-foundation.org>
References: <1223387841.26330.36.camel@lappy.programming.kicks-ass.net>  <48EB6D2C.30806@linux-foundation.org>  <1223391655.13453.344.camel@calx> <1223395846.26330.55.camel@lappy.programming.kicks-ass.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 7 Oct 2008, Peter Zijlstra wrote:
> 
> Tested-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

Heh. Can we get a sign-off and a nice commit message?

		Linus
