Return-Path: <linux-kernel-owner+w=401wt.eu-S1753374AbYJDMqH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374AbYJDMqH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 08:46:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751041AbYJDMpz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 08:45:55 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55099 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750815AbYJDMpy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 08:45:54 -0400
Date: Sat, 4 Oct 2008 14:45:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Tracepoints synchronize unregister static inline
Message-ID: <20081004124538.GF3728@elte.hu>
References: <20081003190133.GA12685@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081003190133.GA12685@Krystal>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.1573]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> Ingo, could you pull the following patch into -tip ?

sure - but it does not apply to tip/master. Some missing dependencies?

	Ingo
