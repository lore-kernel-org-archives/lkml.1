Return-Path: <linux-kernel-owner+w=401wt.eu-S1754760AbXEGSkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760AbXEGSkz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 14:40:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754666AbXEGSky
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 14:40:54 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49851 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754096AbXEGSky (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 14:40:54 -0400
Date: Mon, 7 May 2007 20:40:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: James Cloos <cloos@jhcloos.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch] CFS scheduler, -v10
Message-ID: <20070507184047.GA24430@elte.hu>
References: <20070507163342.GA3502@elte.hu> <m3abwgqy5m.fsf@lugabout.jhcloos.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m3abwgqy5m.fsf@lugabout.jhcloos.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* James Cloos <cloos@jhcloos.com> wrote:

> If instead of pulling master into the cfs branch, I rather switch to 
> the master branch and pull the cfs branch into that, it works.

ah! Could you please do a git-diff between the broken and the working 
tree, to see what got mismerged?

	Ingo
