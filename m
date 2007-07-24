Return-Path: <linux-kernel-owner+w=401wt.eu-S935874AbXGXJmH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935874AbXGXJmH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 05:42:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763434AbXGXJlI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 05:41:08 -0400
Received: from gate.crashing.org ([63.228.1.57]:40118 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935803AbXGXJlD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 05:41:03 -0400
Subject: Re: [patch] mm: reduce pagetable-freeing latencies
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Hugh Dickins <hugh@veritas.com>
In-Reply-To: <20070724015441.8604d85d.akpm@linux-foundation.org>
References: <20070724083855.GA858@elte.hu>
	 <20070724015441.8604d85d.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 24 Jul 2007 19:40:45 +1000
Message-Id: <1185270045.5439.249.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> What a truly putrid patch.  I am suspecting that this was a quick
> get-you-out-of-trouble thing, which then got forgotten about.
> 
> We have two months to do the "right fix".  Please?

Working on it... 

Ben.


