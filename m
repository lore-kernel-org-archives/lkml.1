Return-Path: <linux-kernel-owner+w=401wt.eu-S1752539AbZCIG7g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752539AbZCIG7g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 02:59:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751945AbZCIG71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 02:59:27 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44868 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751921AbZCIG70 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 02:59:26 -0400
Date: Mon, 9 Mar 2009 07:58:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: linux-tip-commits@vger.kernel.org, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       akpm@linux-foundation.org, tglx@linutronix.de, stable@kernel.org
Subject: Re: [tip:x86/mm] x86: fix bootmem cross node for 32bit numa
Message-ID: <20090309065837.GC7057@elte.hu>
References: <49AE485B.8000902@kernel.org> <tip-a71edd1f46c8a599509bda478fb4eea27fb0da63@git.kernel.org> <86802c440903081616j3a50cc97yc4fe374e740f84c1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440903081616j3a50cc97yc4fe374e740f84c1@mail.gmail.com>
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


* Yinghai Lu <yinghai@kernel.org> wrote:

> we may need this one (and two followings one) to be applied 
> for stable with 2.6.27, 2.6.28, 2.6.29.

I'm not sure - they are rather complex and intrusive, and the 
further we go back the more conflicting they become.

	Ingo
