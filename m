Return-Path: <linux-kernel-owner+w=401wt.eu-S1760677AbYBARWY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760677AbYBARWY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 12:22:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755009AbYBARWP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 12:22:15 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49263 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756672AbYBARWO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 12:22:14 -0500
Date: Fri, 1 Feb 2008 18:21:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@suse.de>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org, mel@csn.ul.ie
Subject: Re: [PATCH] [2/2] Remove NUMAQ support in io_32.h
Message-ID: <20080201172159.GC13738@elte.hu>
References: <20080201608.475239056@suse.de> <20080201170834.7D0281B416F@basil.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080201170834.7D0281B416F@basil.firstfloor.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <ak@suse.de> wrote:

> Now that the only user does it on its own remove the NUMAQ support 
> macros in io_32.h

thanks, applied.

> The next step would be to convert the preprocessor mess to actually 
> readable standard inlines.

agreed.

	Ingo
