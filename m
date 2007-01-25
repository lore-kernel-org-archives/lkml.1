Return-Path: <linux-kernel-owner+w=401wt.eu-S965282AbXAYMhx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965282AbXAYMhx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 07:37:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965278AbXAYMhx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 07:37:53 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:42581 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965276AbXAYMhw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 07:37:52 -0500
Date: Thu, 25 Jan 2007 13:36:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Rui Nuno Capela <rncbc@rncbc.org>
Cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.20-rc6-rt1 timekeeping_is_continuous question
Message-ID: <20070125123633.GA8684@elte.hu>
References: <11401.194.65.103.1.1169725008.squirrel@www.rncbc.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11401.194.65.103.1.1169725008.squirrel@www.rncbc.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.8
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.8 required=5.9 tests=ALL_TRUSTED,BAYES_50 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	0.5 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4896]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Rui Nuno Capela <rncbc@rncbc.org> wrote:

> I'm having the following traces on every boot; are they of any 
> concern, or should I just ignore and carry on?

please ignore them - i've removed them from the current tree.

	Ingo
