Return-Path: <linux-kernel-owner+w=401wt.eu-S1753352AbYGLFVu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352AbYGLFVu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 01:21:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751278AbYGLFVm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 01:21:42 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60875 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751216AbYGLFVm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 01:21:42 -0400
Date: Sat, 12 Jul 2008 07:21:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
Cc: tglx@linuxtronix.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Fix ldt limit for 64 bit
Message-ID: <20080712052129.GA29033@elte.hu>
References: <1215792286.8831.14.camel@hermes2.karcher.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1215792286.8831.14.camel@hermes2.karcher.local>
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


* Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de> wrote:

> From: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
> 
> Fix size of LDT entries. On x86-64, ldt_desc is a double-sized 
> descriptor.

applied, thanks Michael.

	Ingo
