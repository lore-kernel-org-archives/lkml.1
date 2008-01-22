Return-Path: <linux-kernel-owner+w=401wt.eu-S1756451AbYAVPkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756451AbYAVPkA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 10:40:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751757AbYAVPjx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 10:39:53 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:39472 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751483AbYAVPjw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 10:39:52 -0500
Date: Tue, 22 Jan 2008 16:39:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andi Kleen <andi@firstfloor.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, apw@shadowen.org
Subject: Re: [PATCH 0/2] Relax restrictions on setting CONFIG_NUMA on x86
Message-ID: <20080122153931.GA25936@elte.hu>
References: <20080118153529.12646.5260.sendpatchset@skynet.skynet.ie> <p73hcha9vc5.fsf@bingen.suse.de> <20080119160743.GA8352@csn.ul.ie> <20080122121400.GB31253@elte.hu> <20080122122954.GC10987@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080122122954.GC10987@csn.ul.ie>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0021]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mel Gorman <mel@csn.ul.ie> wrote:

> Sorry, there was a screwup on my behalf. The version I sent still had 
> a stray static inline in it.  It will fail to compile without this.

ok, picked up that fix too, thanks.

	Ingo
