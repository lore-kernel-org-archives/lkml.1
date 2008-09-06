Return-Path: <linux-kernel-owner+w=401wt.eu-S1754374AbYIFRqF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754374AbYIFRqF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 13:46:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752455AbYIFRpz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 13:45:55 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40161 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752206AbYIFRpy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 13:45:54 -0400
Date: Sat, 6 Sep 2008 19:45:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <jbeulich@novell.com>
Cc: tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: adjust dependencies for CONFIG_X86_CMOV
Message-ID: <20080906174537.GP4856@elte.hu>
References: <48B7FEAE.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48B7FEAE.76E4.0078.0@novell.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0222]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jan Beulich <jbeulich@novell.com> wrote:

> Signed-off-by: Jan Beulich <jbeulich@novell.com>

so these are added:

 MK8 || MCORE2 || MCRUSOE || MEFFICEON

especially the Core2 one should be rather relevant, on 32-bit systems.

Applied to tip/x86/cpu, thanks Jan.

	Ingo
