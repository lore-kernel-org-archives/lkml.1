Return-Path: <linux-kernel-owner+w=401wt.eu-S1759233AbXH1PSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759233AbXH1PSW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 11:18:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757494AbXH1PSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 11:18:09 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43054 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754027AbXH1PSH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 11:18:07 -0400
Date: Tue, 28 Aug 2007 17:18:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Subject: [backport] CFS scheduler, -v20.5, for v2.6.22.5, v2.6.21.7,
	v2.6.20.16
Message-ID: <20070828151804.GA23553@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


i've uploaded the -v20.5 CFS backport patches, which includes a handful 
of other (small) fixes, again related to cornercases. It can be picked 
up from the usual place:

    http://people.redhat.com/mingo/cfs-scheduler/

this updates the CFS backport to include the .23-rc4's scheduler plus 
the changes in the latest scheduler tree. Any scheduler problem you 
might find in -v20.5 will likely affect the .23 kernel too so please 
give it a good workout and report any suspicious behavior :-)

	Ingo
