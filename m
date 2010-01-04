Return-Path: <linux-kernel-owner+w=401wt.eu-S1753951Ab0ADWC6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951Ab0ADWC6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 17:02:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753020Ab0ADWC5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 17:02:57 -0500
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:48179 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752965Ab0ADWC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 17:02:56 -0500
Date: Mon, 4 Jan 2010 15:59:45 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Rik van Riel <riel@redhat.com>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>,
       "hugh.dickins" <hugh.dickins@tiscali.co.uk>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC][PATCH 0/8] Speculative pagefault -v3
In-Reply-To: <4B42606F.3000906@redhat.com>
Message-ID: <alpine.DEB.2.00.1001041558350.17041@router.home>
References: <20100104182429.833180340@chello.nl> <4B42606F.3000906@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Jan 2010, Rik van Riel wrote:

> Fun, but why do we need this?
>
> What improvements did you measure?

If it measures up to Kame-sans approach then the possible pagefault rate
will at least double ...

