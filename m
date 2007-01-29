Return-Path: <linux-kernel-owner+w=401wt.eu-S1752002AbXA2RLv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752002AbXA2RLv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 12:11:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752004AbXA2RLv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 12:11:51 -0500
Received: from omx1-ext.sgi.com ([192.48.179.11]:41399 "EHLO omx1.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752002AbXA2RLu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 12:11:50 -0500
Date: Mon, 29 Jan 2007 09:11:07 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Andrew Morton <akpm@osdl.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Ingo Molnar <mingo@elte.hu>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 11/14] atomic_ulong_t
In-Reply-To: <20070128132437.299596000@programming.kicks-ass.net>
Message-ID: <Pine.LNX.4.64.0701290910060.28330@schroedinger.engr.sgi.com>
References: <20070128131343.628722000@programming.kicks-ass.net>
 <20070128132437.299596000@programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Jan 2007, Peter Zijlstra wrote:

> provide an unsigned long atomic type.

Is this really necessary? We have no atomic_uint_t type either.

Could you use atomic_long_t instead?

