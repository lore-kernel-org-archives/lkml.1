Return-Path: <linux-kernel-owner+w=401wt.eu-S1761234AbXHXOjg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761234AbXHXOjg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 10:39:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754552AbXHXOj0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 10:39:26 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58177 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752858AbXHXOjZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 10:39:25 -0400
Date: Fri, 24 Aug 2007 16:39:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Subject: [patch] CFS scheduler, -v20.3, for v2.6.22.5, v2.6.21.7, v2.6.20.16
Message-ID: <20070824143921.GA21608@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.0.3
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4718]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


i've uploaded the -v20.3 CFS backport patches, which includes a handful 
of other (small) fixes as well, two of which could improve interactivity 
corner-cases. It can be picked up from the usual place:

    http://people.redhat.com/mingo/cfs-scheduler/

	Ingo
