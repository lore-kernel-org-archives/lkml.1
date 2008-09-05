Return-Path: <linux-kernel-owner+w=401wt.eu-S1754747AbYIEQOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747AbYIEQOR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 12:14:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753875AbYIEQOC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 12:14:02 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53467 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753819AbYIEQOA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 12:14:00 -0400
Date: Fri, 5 Sep 2008 18:13:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@qumranet.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] sched_clock: fix NOHZ interaction
Message-ID: <20080905161340.GN10292@elte.hu>
References: <48BABC19.1060509@qumranet.com> <1220281088.8426.63.camel@twins> <48BC15B6.6030506@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48BC15B6.6030506@qumranet.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.1914]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Avi Kivity <avi@qumranet.com> wrote:

> Peter Zijlstra wrote:
>> Avi, the below fixes it for me..
>>   
>
> For me too.  Thanks!

applied to tip/sched/urgent - thanks!

	Ingo
