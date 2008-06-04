Return-Path: <linux-kernel-owner+w=401wt.eu-S1760057AbYFDK1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760057AbYFDK1T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 06:27:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753970AbYFDK1H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 06:27:07 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51733 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753865AbYFDK1G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 06:27:06 -0400
Date: Wed, 4 Jun 2008 12:26:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: move e820_register_active to e820.c
Message-ID: <20080604102645.GD22971@elte.hu>
References: <200806031025.55026.yhlu.kernel@gmail.com> <200806031934.01198.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806031934.01198.yhlu.kernel@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0168]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> to prepare 32 bit to use it
> 
> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

applied, thanks.

	Ingo
