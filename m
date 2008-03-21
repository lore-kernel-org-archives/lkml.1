Return-Path: <linux-kernel-owner+w=401wt.eu-S1756244AbYCUM6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244AbYCUM6S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 08:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753995AbYCUM6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 08:58:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38176 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753837AbYCUM6I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 08:58:08 -0400
Date: Fri, 21 Mar 2008 13:57:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pavel Machek <pavel@ucw.cz>
Cc: ak@suse.de, kernel list <linux-kernel@vger.kernel.org>
Subject: Re: clean up aperture_64.c
Message-ID: <20080321125755.GC27245@elte.hu>
References: <20080313100358.GA3327@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080313100358.GA3327@elf.ucw.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.3
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.2914]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pavel Machek <pavel@ucw.cz> wrote:

> Initializing to zero is generally bad idea, I hope it is right for 
> __init data, too.

thanks Pavel, applied.

	Ingo
