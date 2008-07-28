Return-Path: <linux-kernel-owner+w=401wt.eu-S1756904AbYG1OyK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756904AbYG1OyK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 10:54:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752231AbYG1Ow5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 10:52:57 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58805 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752144AbYG1Ow4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 10:52:56 -0400
Date: Mon, 28 Jul 2008 16:52:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, peterz@infradead.org,
       mingo <mingo@redhat.com>, akpm <akpm@linux-foundation.org>,
       gregkh <greg@kroah.com>
Subject: Re: [PATCH] locking: fix mutex @key parameter kernel-doc notation
Message-ID: <20080728145209.GI18144@elte.hu>
References: <20080724165842.fbae8993.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080724165842.fbae8993.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0080]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Randy Dunlap <randy.dunlap@oracle.com> wrote:

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix @key parameter to mutex_init() and one of its callers.
> 
> Warning(linux-2.6.26-git11//drivers/base/class.c:210): No description 
> found for parameter 'key'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

applied to tip/core/urgent, thanks Randy. Greg, any objections?

	Ingo
