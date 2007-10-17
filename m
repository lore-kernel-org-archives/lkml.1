Return-Path: <linux-kernel-owner+w=401wt.eu-S1765693AbXJQH0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765693AbXJQH0b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 03:26:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764210AbXJQH0P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 03:26:15 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59801 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764158AbXJQH0N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 03:26:13 -0400
Date: Wed, 17 Oct 2007 09:25:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, shemminger@linux-foundation.org
Subject: Re: [patch] forcedeth: fix the NAPI poll function
Message-ID: <20071017072551.GD18044@elte.hu>
References: <20071015112430.GA30006@elte.hu> <20071015.125731.79447899.davem@davemloft.net> <20071015220357.GA7174@elte.hu> <20071015220720.GA16101@elte.hu> <20071015223009.GA27425@elte.hu> <47152B32.9020905@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47152B32.9020905@pobox.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeff Garzik <jgarzik@pobox.com> wrote:

> Would the attached patch be ok with people?
> 
> It's basically the same thing, except that it aligns a bit more 
> closely with forcedeth rework stuff I'm doing.
> 
> I'll send upstream today unless people scream...

looks good to me.

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
