Return-Path: <linux-kernel-owner+w=401wt.eu-S965524AbXDBOYI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965524AbXDBOYI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 10:24:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965513AbXDBOYH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 10:24:07 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37375 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965489AbXDBOYG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 10:24:06 -0400
Date: Mon, 2 Apr 2007 16:23:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "dave_sperry@ieee.org" <dasperry@comcast.net>
Cc: Dave Sperry <dave_sperry@ieee.org>, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Poor UDP performance using 2.6.21-rc5-rt5
Message-ID: <20070402142358.GA32103@elte.hu>
References: <040220071409.15202.46110E98000A743600003B622205886172979D9D0A9F9C0E0B@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <040220071409.15202.46110E98000A743600003B622205886172979D9D0A9F9C0E0B@comcast.net>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* dave_sperry@ieee.org <dasperry@comcast.net> wrote:

> Thanks for all the input Ingo, Here's a list of all the permutations 
> I've tried:

one thing i noticed is that cyclesoak interferes with the netperf 
workload. This is quite surprising. 'top' and 'vmstat' output is 
reliable on -rt, and the overhead goes down if i stop cyclesoak.

	Ingo
