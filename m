Return-Path: <linux-kernel-owner+w=401wt.eu-S1758655AbYEIJYz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758655AbYEIJYz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 05:24:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752780AbYEIJYs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 05:24:48 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:32850 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751061AbYEIJYs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 05:24:48 -0400
Date: Fri, 9 May 2008 11:24:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 0/2] x86 cleanup - use processor-flags.h
Message-ID: <20080509092434.GA13650@elte.hu>
References: <48231b9f.0405560a.12eb.fffff2f0@mx.google.com> <48232F3A.6030000@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48232F3A.6030000@zytor.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0234]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> Cyrill Gorcunov wrote:
>> Trivial changes to use predefined flags from processor-flags.h
>> Please review
>
> Acked-by: H. Peter Anvin <hpa@zytor.com>

thanks, applied.

	Ingo
