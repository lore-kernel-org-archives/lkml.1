Return-Path: <linux-kernel-owner+w=401wt.eu-S1754147AbYIER6w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147AbYIER6w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 13:58:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751090AbYIER6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 13:58:44 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35534 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751324AbYIER6n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 13:58:43 -0400
Date: Fri, 5 Sep 2008 19:58:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Robert Richter <robert.richter@amd.com>
Cc: Vegard Nossum <vegard.nossum@gmail.com>, Pavel Machek <pavel@suse.cz>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Philippe Elie <phil.el@wanadoo.fr>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: oprofile + hibernation = badness
Message-ID: <20080905175827.GE27395@elte.hu>
References: <19f34abd0808181332k3c02496auabd04e927bb7cab5@mail.gmail.com> <48AA1E42.6070802@linux.intel.com> <20080901163452.GD6588@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080901163452.GD6588@erda.amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0005]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


hi Robert,

* Robert Richter <robert.richter@amd.com> wrote:

> Ingo,
> 
> this fix (commit id 1404e403) is not yet upstream for v2.6.27. Could
> this be added to the next pull request?

it's already upstream, as commit 80a8c9fffa. I've zapped the duplicate 
1404e403 from x86/oprofile.

	Ingo
