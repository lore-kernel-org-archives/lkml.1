Return-Path: <linux-kernel-owner+w=401wt.eu-S1758024AbYDIUnQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758024AbYDIUnQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 16:43:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754328AbYDIUnC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 16:43:02 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40309 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753710AbYDIUnA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 16:43:00 -0400
Date: Wed, 9 Apr 2008 22:42:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Pavel Machek <pavel@suse.cz>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: build error on x86_64 with x86.git#latest
Message-ID: <20080409204250.GD18968@elte.hu>
References: <86802c440804091036p3a3837e8td8f17d6195561aaf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440804091036p3a3837e8td8f17d6195561aaf@mail.gmail.com>
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


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> commit 0465ac59164eda30f4fe49006a67dd6d2c9fc3cf
> Author: Pavel Machek <pavel@suse.cz>
> Date:   Wed Feb 20 01:48:39 2008 +0100
> 
>     suspend: wakeup code in c

oops, that was not meant to be pushed out at all - it was just a 
temporary merge which clearly needed more work.

it's all fixed up now - please let me know if you still see any 
problems.

	Ingo
