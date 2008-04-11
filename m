Return-Path: <linux-kernel-owner+w=401wt.eu-S1759891AbYDKJAn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759891AbYDKJAn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 05:00:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759761AbYDKJAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 05:00:06 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57676 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759745AbYDKJAD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 05:00:03 -0400
Date: Fri, 11 Apr 2008 10:59:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Auke Kok <auke-jan.h.kok@intel.com>
Cc: torvalds@linux-foundation.org, jeff@garzik.org, andi@firstfloor.org,
       netdev@vger.kernel.org, e1000-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, davem@davemloft.net,
       akpm@linux-foundation.org
Subject: Re: [PATCH] e1000e: set CONFIG_E1000E=y in x86 defconfigs
Message-ID: <20080411085942.GB10801@elte.hu>
References: <20080409201739.14581.7454.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080409201739.14581.7454.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Auke Kok <auke-jan.h.kok@intel.com> wrote:

> This adds to the already default CONFIG_E1000=y in these files.

thanks, applied.

	Ingo
