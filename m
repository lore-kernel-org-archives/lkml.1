Return-Path: <linux-kernel-owner+w=401wt.eu-S1760299AbYEMNBm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760299AbYEMNBm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 09:01:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756151AbYEMNBW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 09:01:22 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57483 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755588AbYEMNBW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 09:01:22 -0400
Date: Tue, 13 May 2008 15:01:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: amd opteron TOM2 mask val fix
Message-ID: <20080513130104.GJ14973@elte.hu>
References: <200805121740.40070.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805121740.40070.yhlu.kernel@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0228]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> there is typo with the mask. need to remove that extra 0. to avoid 
> 4bits was cleared.

applied, thanks.

	Ingo
