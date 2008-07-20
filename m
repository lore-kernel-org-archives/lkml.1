Return-Path: <linux-kernel-owner+w=401wt.eu-S1758484AbYGTRlJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758484AbYGTRlJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 13:41:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757899AbYGTRkz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 13:40:55 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40969 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757827AbYGTRky (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 13:40:54 -0400
Date: Sun, 20 Jul 2008 19:40:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh <jaswinder@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, torvalds@linux-foundation.org,
       kernelnewbies <kernelnewbies@nl.linux.org>,
       kernel-janitors <kernel-janitors@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] x86-kernel: declare some functions before they get used
Message-ID: <20080720174018.GA16827@elte.hu>
References: <1216050964.2719.4.camel@jaswinder.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1216050964.2719.4.camel@jaswinder.satnam>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0002]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jaswinder Singh <jaswinder@infradead.org> wrote:

> x86-kernel: declare some functions before they get used

i like this cleanup - would you mind to do a version of this patch that 
applies to Linus's latest -git tree?

	Ingo
