Return-Path: <linux-kernel-owner+w=401wt.eu-S1755364AbYI3Hun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364AbYI3Hun (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 03:50:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753589AbYI3HqK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 03:46:10 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33602 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754327AbYI3HqI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 03:46:08 -0400
Date: Tue, 30 Sep 2008 09:45:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] x86: mtrr_cleanup prepare to make gran_size to
	less 1M
Message-ID: <20080930074552.GA19366@elte.hu>
References: <1222739652-17169-1-git-send-email-yhlu.kernel@gmail.com> <48E1A5E8.3030304@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48E1A5E8.3030304@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.3
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.2512]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> Applied series to tip:x86/mtrr, thanks!

tested them and pushed it out into tip/master.

	Ingo
