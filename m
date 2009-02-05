Return-Path: <linux-kernel-owner+w=401wt.eu-S1760554AbZBEUAP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760554AbZBEUAP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 15:00:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753325AbZBET77
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 14:59:59 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59613 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752845AbZBET76 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 14:59:58 -0500
Date: Thu, 5 Feb 2009 20:59:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Ben Greear <greearb@candelatech.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, rusty@rustcorp.com.au
Subject: Re: PATCH:  Allow user to force 'tsc' to be treated as stable.
Message-ID: <20090205195945.GE3129@elte.hu>
References: <498B42C5.7010905@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <498B42C5.7010905@candelatech.com>
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


* Ben Greear <greearb@candelatech.com> wrote:

> Allow user to force TSC as stable clock-source.
> Works around BIOS issues in the FWA-7304 (Via CN700 chipset)
> system, and possibly others.
>
> This is against 2.6.29-rc3.

What 'issues' does that work around, exactly?

	Ingo
