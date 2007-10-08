Return-Path: <linux-kernel-owner+w=401wt.eu-S1755148AbXJHLoc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755148AbXJHLoc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 07:44:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753843AbXJHLoY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 07:44:24 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53082 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753495AbXJHLoY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 07:44:24 -0400
Date: Mon, 8 Oct 2007 13:44:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [4/6] scheduler: Refactor normalize_rt_tasks
Message-ID: <20071008114420.GD22199@elte.hu>
References: <200710071059.126674000@suse.de> <20071007205957.6DABB1474B@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071007205957.6DABB1474B@wotan.suse.de>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <ak@suse.de> wrote:

> Replace a particularly ugly ifdef with an inline and a new macro. Also 
> split up the function to be easier readable.

thanks, applied.

	Ingo
