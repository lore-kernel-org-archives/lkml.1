Return-Path: <linux-kernel-owner+w=401wt.eu-S1760171AbYFXQid@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760171AbYFXQid (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 12:38:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752754AbYFXQiZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 12:38:25 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54812 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752719AbYFXQiZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 12:38:25 -0400
Date: Tue, 24 Jun 2008 18:38:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [Patch] arch/x86/kernel/machine_kexec_32.c: remove extra
	semicolons
Message-ID: <20080624163803.GB8219@elte.hu>
References: <20080624152118.GE10512@hack.voiplan.pt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080624152118.GE10512@hack.voiplan.pt>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0354]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* WANG Cong <xiyou.wangcong@gmail.com> wrote:

> I can't see any reason to keep these semicolons.

/me neither :-)

applied to tip/x86/cleanups, thanks!

	Ingo
