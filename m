Return-Path: <linux-kernel-owner+w=401wt.eu-S1756832AbYCYP7b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756832AbYCYP7b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 11:59:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755499AbYCYP7Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 11:59:24 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52285 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755567AbYCYP7Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 11:59:24 -0400
Date: Tue, 25 Mar 2008 16:59:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: gorcunov@gmail.com
Cc: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 0/4] x86 - relocate_kernel cleanup
Message-ID: <20080325155906.GE27174@elte.hu>
References: <20080322210005.117475478@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080322210005.117475478@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0236]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* gorcunov@gmail.com <gorcunov@gmail.com> wrote:

> The main purpose of this patches is to eliminate numeric constant and 
> use predefined macroses. Please review. I've tested 64bit version on 
> object level - it remains the same. Any comments are welcome.

thanks Cyrill, i've applied all four patches of yours.

	Ingo
