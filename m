Return-Path: <linux-kernel-owner+w=401wt.eu-S1756627AbYCULzq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756627AbYCULzq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 07:55:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753358AbYCULzi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 07:55:38 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43563 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752722AbYCULzh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 07:55:37 -0400
Date: Fri, 21 Mar 2008 12:55:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Heinz-Ado Arnolds <arnolds@MPA-Garching.MPG.DE>
Cc: linux-kernel@vger.kernel.org, Douglas_Warzecha@dell.com,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Reboot problem with Dell Optiplex 745 on 2.6.23/24
Message-ID: <20080321115521.GC25225@elte.hu>
References: <47D7F67C.5040406@MPA-Garching.MPG.DE>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47D7F67C.5040406@MPA-Garching.MPG.DE>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.2.3
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4926]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Heinz-Ado Arnolds <arnolds@MPA-Garching.MPG.DE> wrote:

> Hi there,
>
> we have seen a little problem in rebooting Dell Optiplex 745 with the 
> 0KW626 board. A small patch for 2.6.23 enabling reboot with this board 
> is attached.

thanks Heinz, applied.

	Ingo
