Return-Path: <linux-kernel-owner+w=401wt.eu-S1757939AbYLLHJi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757939AbYLLHJi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 02:09:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751920AbYLLHJa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 02:09:30 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56962 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751411AbYLLHJa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 02:09:30 -0500
Date: Fri, 12 Dec 2008 08:09:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Markus Metzger <markus.t.metzger@intel.com>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       markus.t.metzger@gmail.com, roland@redhat.com,
       akpm@linux-foundation.org, eranian@googlemail.com
Subject: Re: [patch 1/3] x86, bts: turn BUG_ON into WARN_ON_ONCE
Message-ID: <20081212070904.GA7589@elte.hu>
References: <20081211134523.A13571@sedona.ch.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081211134523.A13571@sedona.ch.intel.com>
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


* Markus Metzger <markus.t.metzger@intel.com> wrote:

> Turn BUG_ON's into WARN_ON_ONCE.
> 
> Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>

applied to tip/tracing/hw-branch-tracing, thanks Markus!

	Ingo
