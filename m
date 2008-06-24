Return-Path: <linux-kernel-owner+w=401wt.eu-S1759285AbYFXQgu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759285AbYFXQgu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 12:36:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751132AbYFXQgn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 12:36:43 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38040 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751197AbYFXQgm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 12:36:42 -0400
Date: Tue, 24 Jun 2008 18:36:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: tglx@linutronix.de, hpa@zytor.com, macro@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 1/5] x86: perfctr-watchdog.c - coding style cleanup
Message-ID: <20080624163622.GA8219@elte.hu>
References: <20080624161624.124913675@gmail.com>> <48611ec1.2234440a.679b.1a7d@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48611ec1.2234440a.679b.1a7d@mx.google.com>
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


* Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> Just some code beautification. Nothing else.

applied, thanks Cyrill.

note, your mailer sets the wrong timestamps:

| Date: Thu, 01 Jan 1970 03:00:01 +0300
| From: Cyrill Gorcunov <gorcunov@gmail.com>

i'll edit them out of your patches so that Git doesnt get bogus dates.

	Ingo
