Return-Path: <linux-kernel-owner+w=401wt.eu-S1752067AbYCLKpY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752067AbYCLKpY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 06:45:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751369AbYCLKpM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 06:45:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45996 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751351AbYCLKpK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 06:45:10 -0400
Date: Wed, 12 Mar 2008 11:44:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] x86 halt warning fix
Message-ID: <20080312104428.GA32359@elte.hu>
References: <20080312100848.GA2768@darkstar.te-china.tietoenator.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080312100848.GA2768@darkstar.te-china.tietoenator.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0429]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dave Young <hidave.darkstar@gmail.com> wrote:

> While halting kernel report warning at arch/x86/kernel/reboot.c : 424 
> fix the WARN_ON_ONCE param to ret

thanks, applied.

	Ingo
