Return-Path: <linux-kernel-owner+w=401wt.eu-S1754003AbZJ2Odh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003AbZJ2Odh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 10:33:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753688AbZJ2Odg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 10:33:36 -0400
Received: from nfitmail.nfit.au.dk ([130.225.31.129]:20947 "EHLO
	smtp.nfit.au.dk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753672AbZJ2Odg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 10:33:36 -0400
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl
Subject: Re: [PATCH 0/2] Some fixes to debug_kmap_atomic()
References: <ye84opj9zgs.fsf@camel23.daimi.au.dk>
	<20091029090741.GC22963@elte.hu>
From: Soeren Sandmann <sandmann@daimi.au.dk>
Date: 29 Oct 2009 15:33:39 +0100
In-Reply-To: <20091029090741.GC22963@elte.hu>
Message-ID: <ye83a522rss.fsf@camel27.daimi.au.dk>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-NFIT-RelayAddr: 130.225.16.146
X-NFIT-Solido-Score: 0.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

> hm, have you seen this patch from Peter on lkml:
> 
>   [RFC][PATCH] kmap_atomic_push
> 
> which eliminates debug_kmap_atomic().

I hadn't; that would work as well, though fixing the infinite stream
of warning is maybe embarrassing enough that it should be in 2.6.32?


Soren
