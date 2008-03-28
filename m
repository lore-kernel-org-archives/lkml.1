Return-Path: <linux-kernel-owner+w=401wt.eu-S1756841AbYC1UOA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756841AbYC1UOA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 16:14:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753359AbYC1UNw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 16:13:52 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57266 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753180AbYC1UNw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 16:13:52 -0400
Date: Fri, 28 Mar 2008 21:13:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jack Steiner <steiner@sgi.com>
Cc: tglx@linutronix.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 0/8] - Support for UV platform
Message-ID: <20080328201337.GA26555@elte.hu>
References: <20080328191156.GA16415@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080328191156.GA16415@sgi.com>
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


* Jack Steiner <steiner@sgi.com> wrote:

> This series of patches add x86_64 support for the SGI "UV" platform. 
> Most of the changes are related to support for larger apic IDs and new 
> chipset hardware that is used for sending IPIs, etc.

thanks Jack, applied.

	Ingo
