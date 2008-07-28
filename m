Return-Path: <linux-kernel-owner+w=401wt.eu-S1755657AbYG1PZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755657AbYG1PZj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 11:25:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757079AbYG1PZ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 11:25:26 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37430 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757099AbYG1PZZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 11:25:25 -0400
Date: Mon, 28 Jul 2008 17:25:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Bernhard Walle <bwalle@suse.de>
Cc: linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>
Subject: Re: x86: move dma32_reserve_bootmem() after reserve_crashkernel()
Message-ID: <20080728152512.GJ32111@elte.hu>
References: <20080727002559.48cee0d4@kopernikus.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080727002559.48cee0d4@kopernikus.site>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.1152]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Bernhard Walle <bwalle@suse.de> wrote:

> Hi Ingo,
> 
> can you send 91467bdf6e53058af13fd255375d6634ba0c70e0 (in 
> x86/crashdump) to Linus still for 2.6.27? I want that also in stable 
> for 2.6.26, and Greg KH stated that it must be first in Linus' tree.

ok - i've merged it into x86/urgent.

	Ingo
