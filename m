Return-Path: <linux-kernel-owner+w=401wt.eu-S1755610AbYCUL0c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755610AbYCUL0c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 07:26:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754548AbYCUL0Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 07:26:24 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36975 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754324AbYCUL0X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 07:26:23 -0400
Date: Fri, 21 Mar 2008 12:26:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Glauber Costa <glommer@gmail.com>,
       Linux Kernel ML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: change pci_direct_conf1 back not static
Message-ID: <20080321112606.GD20420@elte.hu>
References: <86802c440803181102i5175c12cw7c41b3f68de38f04@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440803181102i5175c12cw7c41b3f68de38f04@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.3
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.2720]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> Glauber Costa <glommer@gmail.com> pointed out
> 
>     commit 513f484dfe5cbb53e73ef1729703e7030e799487
> 
>     x86 pci: remove checking type for mmconfig probe v2
> 
> broke the VISW.
> 
> remove the static in declaration.

thanks, applied.

	Ingo
