Return-Path: <linux-kernel-owner+w=401wt.eu-S1753887AbYIYKkm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887AbYIYKkm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 06:40:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753013AbYIYKke
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 06:40:34 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35550 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752999AbYIYKkd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 06:40:33 -0400
Date: Thu, 25 Sep 2008 12:40:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Hugh Dickins <hugh@veritas.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: Re: [PATCH 1/3] corruption check: move the corruption checks into
	their own file
Message-ID: <20080925104010.GB15720@elte.hu>
References: <20080923215335.05678239@infradead.org> <20080923225306.09fc27b4.akpm@linux-foundation.org> <20080924101608.5c99612e@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080924101608.5c99612e@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.1549]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arjan van de Ven <arjan@infradead.org> wrote:

> I'll look at your cleanup suggestions as another separate patch please 

yes, that's natural. Anything that isnt super-important to backmerge 
should go into a separate patch.

	Ingo
