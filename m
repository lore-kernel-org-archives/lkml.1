Return-Path: <linux-kernel-owner+w=401wt.eu-S1754611AbYDMHsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611AbYDMHsS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 03:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751768AbYDMHsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 03:48:11 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55951 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751569AbYDMHsK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 03:48:10 -0400
Date: Sun, 13 Apr 2008 09:47:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: yhlu.kernel@gmail.com, kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86_64: don't need set default res if only have one
	root bus
Message-ID: <20080413074753.GH20332@elte.hu>
References: <200804111514.53680.yhlu.kernel@gmail.com> <200804120054.01959.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804120054.01959.rjw@sisk.pl>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0083]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> On Saturday, 12 of April 2008, Yinghai Lu wrote:
> > only one root bus, don't need to split that root resources.
> 
> This patch fixes the issue described at
> http://lkml.org/lkml/2008/4/10/304 and in the following thread for me.
> 
> > Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
> 
> Tested-by: Rafael J. Wysocki <rjw@sisk.pl>

thanks - applied.

	Ingo
