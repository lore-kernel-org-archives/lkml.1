Return-Path: <linux-kernel-owner+w=401wt.eu-S934633AbYAaWpd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934633AbYAaWpd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 17:45:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762366AbYAaWpX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 17:45:23 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:42359 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762341AbYAaWpW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 17:45:22 -0500
Date: Thu, 31 Jan 2008 23:45:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Ian Campbell <ijc@hellion.org.uk>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: define OBJCOPYFLAGS explicitly for each target.
Message-ID: <20080131224505.GB24974@elte.hu>
References: <1201815920-24669-1-git-send-email-ijc@hellion.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1201815920-24669-1-git-send-email-ijc@hellion.org.uk>
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


* Ian Campbell <ijc@hellion.org.uk> wrote:

> Do this rather than defining a global version and overriding it in 
> almost all cases in order to make subsequent patches simpler.

thanks Ian - i've picked up #1, #2 and #4 from your series. Once #3 is 
OK to Peter i'll add that too. (#4, the bumping of the version needs 
#3 to be meaningful.)

	Ingo
