Return-Path: <linux-kernel-owner+w=401wt.eu-S1759477AbYBMMYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759477AbYBMMYR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 07:24:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756159AbYBMMYA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 07:24:00 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:39645 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753347AbYBMMX7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 07:23:59 -0500
Date: Wed, 13 Feb 2008 13:23:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Jody Belka <lists-lkml@pimb.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ian Campbell <ijc@hellion.org.uk>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andi Kleen <andi@firstfloor.org>,
       Mika Penttila <mika.penttila@kolumbus.fi>
Subject: Re: 2.6.25-rc1 xen pvops regression
Message-ID: <20080213122332.GA5283@elte.hu>
References: <20080212235404.GY7980@pimb.org> <47B2DBA5.6030001@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47B2DBA5.6030001@goop.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.3
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Although I'm on vacation, I happened to download a recent copy of 
> x86.git and found that it crashes early.  Here's a couple of patches 
> to apply; I don't know if they apply to current git, but I hope it 
> helps.

thanks Jeremy, applied.

	Ingo
