Return-Path: <linux-kernel-owner+w=401wt.eu-S1755192AbYCKKEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192AbYCKKEe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 06:04:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751366AbYCKKE0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 06:04:26 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47824 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751242AbYCKKE0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 06:04:26 -0400
Date: Tue, 11 Mar 2008 11:03:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] kgdb: Add kgdb internal test suite
Message-ID: <20080311100359.GV25110@elte.hu>
References: <1204929257-9967-1-git-send-email-jason.wessel@windriver.com> <1204929257-9967-2-git-send-email-jason.wessel@windriver.com> <1204929257-9967-3-git-send-email-jason.wessel@windriver.com> <20080310074047.GA16906@elte.hu> <47D53E09.9030107@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47D53E09.9030107@windriver.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0013]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jason Wessel <jason.wessel@windriver.com> wrote:

> > please also add a Kconfig way to activate them and let them be 
> > executed automatically upon bootup. If any test fails it should 
> > generate a WARN_ON() type of message (for automated testers to 
> > find).
> 
> Easy enough.  I folded the attached patch into the original kgdbts 
> patch in the for_ingo branch.

great, thanks!

	Ingo
