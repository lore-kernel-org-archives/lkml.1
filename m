Return-Path: <linux-kernel-owner+w=401wt.eu-S1764232AbZAUL1l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764232AbZAUL1l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 06:27:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756024AbZAUL1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 06:27:31 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34994 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755400AbZAUL1b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 06:27:31 -0500
Date: Wed, 21 Jan 2009 12:27:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <jbeulich@novell.com>
Cc: linux-kernel@vger.kernel.org, Thomas Renninger <trenn@suse.de>
Subject: Re: [PATCH] x86: mtrr fix debug parameter
Message-ID: <20090121112722.GE23469@elte.hu>
References: <200901201037.39981.trenn@suse.de> <4975B139.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4975B139.76E4.0078.0@novell.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.2.3
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4991]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jan Beulich <jbeulich@novell.com> wrote:

> I've been carrying a change like this for quite some time in a bigger patch,
> but never got to actually split it out and submit it. Thanks for doing this,
> Thomas! (And yes, it did work at the time it was added.)
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>

applied to tip/x86/urgent, thanks guys!

	Ingo
