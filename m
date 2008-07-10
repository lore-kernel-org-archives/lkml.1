Return-Path: <linux-kernel-owner+w=401wt.eu-S1756639AbYGJKkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756639AbYGJKkh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 06:40:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752910AbYGJKk1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 06:40:27 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43812 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752751AbYGJKk1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 06:40:27 -0400
Date: Thu, 10 Jul 2008 12:40:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mattias Nissler <mattias.nissler@gmx.de>
Cc: Vegard Nossum <vegard.nossum@gmail.com>,
       Stefano Brivio <stefano.brivio@polimi.it>,
       "John W. Linville" <linville@tuxdriver.com>,
       "David S. Miller" <davem@davemloft.net>,
       Pekka Enberg <penberg@cs.helsinki.fi>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] rc80211_pid: Fix fast_start parameter handling
Message-ID: <20080710104007.GB30650@elte.hu>
References: <19f34abd0807070427w5398c617uae0a4e8e40fd8f0e@mail.gmail.com> <1215464899.4416.22.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1215464899.4416.22.camel@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mattias Nissler <mattias.nissler@gmx.de> wrote:

> [...] This also fixes uninitialized memory references to the 
> fast_start and norm_offset parameters detected by the kmemcheck 
> utility.

cool :-)

	Ingo
