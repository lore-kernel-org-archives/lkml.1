Return-Path: <linux-kernel-owner+w=401wt.eu-S1752056AbXA3IcF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056AbXA3IcF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 03:32:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752088AbXA3IcF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 03:32:05 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45157 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752056AbXA3IcE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 03:32:04 -0500
Date: Tue, 30 Jan 2007 09:30:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@osdl.org>
Cc: Tomasz Kvarsin <kvarsin@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [BUG] 2.6.20-rc3-mm1: can not mount root
Message-ID: <20070130083046.GA9498@elte.hu>
References: <5157576d0701050620l14fd0a6emdf5793c5214931a8@mail.gmail.com> <20070130001209.b716c14a.akpm@osdl.org> <20070130082244.GA5942@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070130082244.GA5942@elte.hu>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.3 required=5.9 tests=ALL_TRUSTED,BAYES_40 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	1.0 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.3720]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> I'll try to reproduce this.

cannot see the crash in qemu - i suspect it's .config dependent. Tomasz, 
could you send me the .config you used?

	Ingo
