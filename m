Return-Path: <linux-kernel-owner+w=401wt.eu-S1763972AbZDHJka@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763972AbZDHJka (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 05:40:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757706AbZDHJkO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 05:40:14 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36740 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756110AbZDHJkM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 05:40:12 -0400
Date: Wed, 8 Apr 2009 11:39:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Han, Weidong" <weidong.han@intel.com>
Cc: "'Len Brown'" <lenb@kernel.org>,
       "Woodhouse, David" <david.woodhouse@intel.com>,
       "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>,
       "'Jesse Barnes'" <jbarnes@virtuousgeek.org>
Subject: Re: 2.6.30-rc1 build failure - drivers/pci/dmar.o
Message-ID: <20090408093956.GC26121@elte.hu>
References: <alpine.LFD.2.00.0904072224590.4799@localhost.localdomain> <715D42877B251141A38726ABF5CABF2C01A2F7C978@pdsmsx503.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <715D42877B251141A38726ABF5CABF2C01A2F7C978@pdsmsx503.ccr.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Han, Weidong <weidong.han@intel.com> wrote:

> It's found and fixed by Ingo and David yesterday. The patch is 
> posted belew. Ingo said he applied it to x86/urgent and will get 
> it to Linus.

i missed -rc1 with that (wanted to wait out more build tests - these 
Kconfig dependencies are twisted) - will probably send it later 
today.

	Ingo
