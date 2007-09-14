Return-Path: <linux-kernel-owner+w=401wt.eu-S1753344AbXININj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344AbXININj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 04:13:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751003AbXININZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 04:13:25 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37046 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750923AbXININY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 04:13:24 -0400
Date: Fri, 14 Sep 2007 10:13:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: dimm <dmitry.adamushko@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: [announce] CFS-devel, performance improvements
Message-ID: <20070914081317.GA16159@elte.hu>
References: <1189723870.4485.18.camel@earth>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1189723870.4485.18.camel@earth>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0049]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* dimm <dmitry.adamushko@gmail.com> wrote:

> Better placement of #ifdef CONFIG_SCHEDSTAT block in dequeue_entity().

thanks, applied.

	Ingo
