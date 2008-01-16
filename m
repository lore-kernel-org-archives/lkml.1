Return-Path: <linux-kernel-owner+w=401wt.eu-S1752294AbYAPVHX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752294AbYAPVHX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 16:07:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750977AbYAPVHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 16:07:10 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44075 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750917AbYAPVHI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 16:07:08 -0500
Date: Wed, 16 Jan 2008 22:06:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@suse.de>
Cc: Jan Beulich <jbeulich@novell.com>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 0 of 4] x86: some more patches
Message-ID: <20080116210646.GA11967@elte.hu>
References: <patchbomb.1200435425@localhost> <200801161840.44683.ak@suse.de> <20080116202234.GC4212@elte.hu> <200801162159.50274.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801162159.50274.ak@suse.de>
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


* Andi Kleen <ak@suse.de> wrote:

> > truly stuck, or just an annoying message?
> 
> Just annoying message; system works after that for simple login etc. 
> (haven't run anything complicated)

ok, if you see no other failures and if you have some time it would be 
nice to figure out why that message is happening. Is NOHZ enabled 
perhaps?

	Ingo
