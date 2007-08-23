Return-Path: <linux-kernel-owner+w=401wt.eu-S1761377AbXHWKZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761377AbXHWKZi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 06:25:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759240AbXHWKZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 06:25:31 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33886 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756770AbXHWKZa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 06:25:30 -0400
Date: Thu, 23 Aug 2007 12:25:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Subject: Re: [patch] CFS scheduler, -v20, for v2.6.22.5, v2.6.21.7,
	v2.6.20.16
Message-ID: <20070823102523.GA5430@elte.hu>
References: <20070823094346.GA26281@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070823094346.GA26281@elte.hu>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.1.7-deb
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.0554]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> By popular demand, here is release -v20 of the CFS scheduler. It is a 
> full backport of the latest & greatest v2.6.23-rc3 CFS code to 
> v2.6.22.5, v2.6.21.7 and v2.6.20.16. The patches can be downloaded 
> from the usual place:

update: i missed a small SMP balancing fix so i've updated the patches 
to -v20.1.

	Ingo
