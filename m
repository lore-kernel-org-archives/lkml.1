Return-Path: <linux-kernel-owner+w=401wt.eu-S1755427AbYKCKHV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427AbYKCKHV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 05:07:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754869AbYKCKHJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 05:07:09 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38234 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754635AbYKCKHI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 05:07:08 -0500
Date: Mon, 3 Nov 2008 11:06:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] Make ftrace able to trace function return
Message-ID: <20081103100656.GF13671@elte.hu>
References: <490A08E3.2040201@gmail.com> <alpine.DEB.1.10.0810301556010.19996@gandalf.stny.rr.com> <c62985530810301705h356decf8oea0db02def2ab3c1@mail.gmail.com> <alpine.DEB.1.10.0810302241420.21031@gandalf.stny.rr.com> <490B6826.7080604@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <490B6826.7080604@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.1347]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> I have a trace in attachment with some good results.

-ENOATTACH

would be nice to see a short comparative section of "before" and 
"after" output within the changelog. That makes the review of such 
changes much more intuitive.

	Ingo
