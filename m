Return-Path: <linux-kernel-owner+w=401wt.eu-S1761130AbYARMgk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761130AbYARMgk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 07:36:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760768AbYARMg1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 07:36:27 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:44064 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760342AbYARMg0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 07:36:26 -0500
Date: Fri, 18 Jan 2008 13:36:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, phil.el@wanadoo.fr,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: x86: Add support for the latest Intel processors to Oprofile
Message-ID: <20080118123610.GK11044@elte.hu>
References: <20080117101613.65bf008b@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080117101613.65bf008b@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Arjan van de Ven <arjan@infradead.org> wrote:

> Subject: x86: Add support for the latest Intel processors to Oprofile
> From: Arjan van de Ven <arjan@linux.intel.com>
> 
> The latest Intel processors (the 45nm ones) have a model number of 23 
> (old ones had 15); they're otherwise compatible on the oprofile side. 
> This patch adds the new model number to the oprofile code.

thanks, applied.

2.6.24 fix too, right?

	Ingo
