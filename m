Return-Path: <linux-kernel-owner+w=401wt.eu-S1760296AbXIJTmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760296AbXIJTmV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 15:42:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760944AbXIJTlw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 15:41:52 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50021 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760117AbXIJTlv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 15:41:51 -0400
Date: Mon, 10 Sep 2007 21:41:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Laurent Vivier <Laurent.Vivier@bull.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RESEND 2][PATCH 0/4] Virtual Machine Time Accounting
Message-ID: <20070910194143.GA6052@elte.hu>
References: <46E550D7.6090805@bull.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46E550D7.6090805@bull.net>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Laurent Vivier <Laurent.Vivier@bull.net> wrote:

> This new version remove conditional compilation on GUEST_ACCOUNTING.

excellent! For all 4 patches:

 Acked-by: Ingo Molnar <mingo@elte.hu>

i'd suggest inclusion into 2.6.24.

can the /proc change break anything? Any old procps version perhaps?

	Ingo
