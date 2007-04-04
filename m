Return-Path: <linux-kernel-owner+w=401wt.eu-S2992821AbXDDKHH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992821AbXDDKHH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 06:07:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992820AbXDDKHG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 06:07:06 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48943 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992817AbXDDKHE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 06:07:04 -0400
Date: Wed, 4 Apr 2007 12:06:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, ego@in.ibm.com, paulmck@us.ibm.com,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       vatsa@in.ibm.com, Oleg Nesterov <oleg@tv-sign.ru>, dipankar@in.ibm.com,
       dino@in.ibm.com, masami.hiramatsu.pt@hitachi.com,
       Roland McGrath <roland@redhat.com>
Subject: Re: utrace merge
Message-ID: <20070404100644.GC19120@elte.hu>
References: <20070402053457.GA9076@in.ibm.com> <20070402061612.GA7072@elte.hu> <20070403120104.GB29308@in.ibm.com> <200704032134.29720.rjw@sisk.pl> <20070403132427.88308b59.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070403132427.88308b59.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> urgh, I screwed up, sorry.
> 
> utrace-prep-2 reverts a bit of the underlying tree so that the utrace 
> patches (which are against mainline) don't throw a tremendous reject 
> which has to be fixed each time I pull Roland's tree.  I'm supposed to 
> reapply that change after the utrace patches but forgot.

btw., how about pushing utrace to v2.6.22, is anything big holding that 
up? (other than Roland's modesty, which we should gently but firmly 
ignore in this case =B-)

	Ingo
