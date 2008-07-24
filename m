Return-Path: <linux-kernel-owner+w=401wt.eu-S1756780AbYGXLxi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756780AbYGXLxi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 07:53:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753329AbYGXLxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 07:53:31 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47074 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753195AbYGXLxa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 07:53:30 -0400
Date: Thu, 24 Jul 2008 13:53:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: linux-kernel@vger.kernel.org, macro@linux-mips.org,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [patch 0/2] x86 apic - a few function merge v2
Message-ID: <20080724115311.GB14369@elte.hu>
References: <20080724114302.028278487@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080724114302.028278487@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0181]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Cyrill Gorcunov <gorcunov@gmail.com> wrote:

>   I don't leave hope to merge APIC code someday (now it becomes harder 
> 'cause of new x(2)APIC code). So these patches merges a few functions. 
> No changes on binary level. Please review. Any comments are welcome!

looks good to me - applied to tip/x86/apic, thanks Cyrill.

	Ingo
