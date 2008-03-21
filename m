Return-Path: <linux-kernel-owner+w=401wt.eu-S1757386AbYCUNBm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757386AbYCUNBm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 09:01:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755057AbYCUNBd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 09:01:33 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55250 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754898AbYCUNBc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 09:01:32 -0400
Date: Fri, 21 Mar 2008 14:01:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alexander van Heukelum <heukelum@mailshack.com>
Cc: Alexander van Heukelum <heukelum@fastmail.fm>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: x86: fix uml with generic find_next_bit for x86
Message-ID: <20080321130120.GE27245@elte.hu>
References: <20080313175351.GA4711@mailshack.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080313175351.GA4711@mailshack.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.3
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.2859]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexander van Heukelum <heukelum@mailshack.com> wrote:

> This fixes uml breakage I introduced in "change x86 to use generic 
> find_next_bit", which is now in x86-testing.

thanks, applied.

	Ingo
