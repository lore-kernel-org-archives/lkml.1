Return-Path: <linux-kernel-owner+w=401wt.eu-S1753832AbZAEKMF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832AbZAEKMF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 05:12:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752377AbZAEKLy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 05:11:54 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:32849 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752707AbZAEKLy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 05:11:54 -0500
Date: Mon, 5 Jan 2009 11:11:36 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.29 -mm merge plans
Message-ID: <20090105101136.GB2059@elte.hu>
References: <20090105004300.19ed52d1.akpm@linux-foundation.org> <20090105090239.GB17530@uranus.ravnborg.org> <20090105011202.835e75ec.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090105011202.835e75ec.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> Maybe we should just do the switch, send best-effort fixup patches at 
> the arch maintainers and move on.

agreed - we should have done that 5 years ago. This is really an arch 
problem and i'm willing to help this effort and fix any new sparc64 
warnings in any sparc64 config that davem sends me.

	Ingo
