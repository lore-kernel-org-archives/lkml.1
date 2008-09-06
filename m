Return-Path: <linux-kernel-owner+w=401wt.eu-S1754343AbYIFQpy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754343AbYIFQpy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 12:45:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752385AbYIFQpq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 12:45:46 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51632 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751532AbYIFQpq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 12:45:46 -0400
Date: Sat, 6 Sep 2008 18:45:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: kill sys32_pause
Message-ID: <20080906164535.GA4856@elte.hu>
References: <20080901013924.GA7947@lst.de> <20080901161451.GA16121@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080901161451.GA16121@lst.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.0928]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Hellwig <hch@lst.de> wrote:

> It's an unused duplicate of the generic sys_pause.
> 
> (now without the b0rked ia64 bits, sorry)
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

applied to tip/x86/cleanups - thanks Christoph. I'm curious, how did you 
find it, some automation - or old-fashioned code reading?

	Ingo
