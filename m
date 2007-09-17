Return-Path: <linux-kernel-owner+w=401wt.eu-S1755681AbXIQOAM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755681AbXIQOAM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 10:00:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754158AbXIQN75
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 09:59:57 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60395 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754157AbXIQN75 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 09:59:57 -0400
Date: Mon, 17 Sep 2007 15:59:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Beauchemin, Mark" <Mark.Beauchemin@sycamorenet.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -rt] Preemption problem in kernel RT Patch
Message-ID: <20070917135944.GB23060@elte.hu>
References: <77B279EC7347F341A6AE891AA6AD68E93142E4@ranchero.sycamorenet.com> <77B279EC7347F341A6AE891AA6AD68E9314369@ranchero.sycamorenet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <77B279EC7347F341A6AE891AA6AD68E9314369@ranchero.sycamorenet.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.1.7-deb
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.1518]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Beauchemin, Mark <Mark.Beauchemin@sycamorenet.com> wrote:

> Ingo,
> 
> 	Any thoughts on the patch?

looks good to me - but it has a number of style issues, please run it 
through scripts/checkpatch.pl to see those.

	Ingo
