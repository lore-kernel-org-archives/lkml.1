Return-Path: <linux-kernel-owner+w=401wt.eu-S1753321AbYEDSHH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321AbYEDSHH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 14:07:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753201AbYEDSG4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 14:06:56 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38028 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752641AbYEDSG4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 14:06:56 -0400
Date: Sun, 4 May 2008 20:06:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Andi Kleen <ak@suse.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] x86: x86-64defconfig remake
Message-ID: <20080504180642.GA19184@elte.hu>
References: <20080504155719.GA6842@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080504155719.GA6842@cvg>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> The current x86_64_defconfig contains a number of nonexistent
> symbols. Lets fix it.

thanks Cyrill, applied. I also fixed up the 32-bit defconfig and did a 
few more updates to both of them as well, to make it more generally 
useful.

	Ingo
