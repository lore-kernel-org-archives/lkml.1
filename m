Return-Path: <linux-kernel-owner+w=401wt.eu-S1754009AbZDGIu7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009AbZDGIu7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 04:50:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751396AbZDGIus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 04:50:48 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41175 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751244AbZDGIur (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 04:50:47 -0400
Date: Tue, 7 Apr 2009 10:49:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Woodhouse <dwmw2@infradead.org>
Cc: torvalds@linux-foundation.org, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT *] intel-iommu updates for 2.6.30 (second batch)
Message-ID: <20090407084950.GA1467@elte.hu>
References: <1238839639.3560.37.camel@macbook.infradead.org> <20090407053739.GA10500@elte.hu> <1239083045.22733.383.camel@macbook.infradead.org> <20090407054818.GA5557@elte.hu> <20090407055245.GA10406@elte.hu> <1239084280.22733.404.camel@macbook.infradead.org> <20090407061558.GA31261@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090407061558.GA31261@elte.hu>
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


there's another new build failure as well:

drivers/pci/intr_remapping.c:680:28: error: macro "if" passed 2 arguments, but takes just 1
drivers/pci/intr_remapping.c:694:28: error: macro "if" passed 2 arguments, but takes just 1
drivers/pci/intr_remapping.c:701:28: error: macro "if" passed 2 arguments, but takes just 1

	Ingo
