Return-Path: <linux-kernel-owner+w=401wt.eu-S1754635AbYEZIr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635AbYEZIr6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 04:47:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753571AbYEZIrt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 04:47:49 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48381 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753079AbYEZIrs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 04:47:48 -0400
Date: Mon, 26 May 2008 10:47:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       drzeus-list@drzeus.cx
Subject: Re: [patch, -git] pcie hotplug bootup crash fix
Message-ID: <20080526084709.GA2182@elte.hu>
References: <20080524165828.GA29993@elte.hu> <20080524104024.a33116a3.akpm@linux-foundation.org> <483A7663.4000700@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <483A7663.4000700@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0203]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com> wrote:

> I updated Ingo's patch. If it's ok, I'll send it to Jess Barnes with 
> some other patches for the other pciehp regression problems.

looks good to me, thanks Kenji.

	Ingo
