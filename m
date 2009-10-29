Return-Path: <linux-kernel-owner+w=401wt.eu-S1753870AbZJ2JHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870AbZJ2JHm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 05:07:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753774AbZJ2JHm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 05:07:42 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39601 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751614AbZJ2JHl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 05:07:41 -0400
Date: Thu, 29 Oct 2009 10:07:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Soeren Sandmann <sandmann@daimi.au.dk>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl
Subject: Re: [PATCH 0/2] Some fixes to debug_kmap_atomic()
Message-ID: <20091029090741.GC22963@elte.hu>
References: <ye84opj9zgs.fsf@camel23.daimi.au.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ye84opj9zgs.fsf@camel23.daimi.au.dk>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Soeren Sandmann <sandmann@daimi.au.dk> wrote:

> Hi, 
> 
> Here are two patches that fix an issue with debug_kmap_atomic(). 

hm, have you seen this patch from Peter on lkml:

  [RFC][PATCH] kmap_atomic_push

which eliminates debug_kmap_atomic().

	Ingo
