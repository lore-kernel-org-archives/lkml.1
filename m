Return-Path: <linux-kernel-owner+w=401wt.eu-S1760745AbZBEAQq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760745AbZBEAQq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 19:16:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756815AbZBEAQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 19:16:36 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:55525 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754383AbZBEAQf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 19:16:35 -0500
Date: Thu, 5 Feb 2009 01:16:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alex Chiang <achiang@hp.com>, linux-kernel <linux-kernel@vger.kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: fix grammar in user-visible BIOS warning
Message-ID: <20090205001628.GD15680@elte.hu>
References: <20090204234401.GA19517@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090204234401.GA19517@ldl.fc.hp.com>
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


* Alex Chiang <achiang@hp.com> wrote:

> Fix user-visible grammo.
> 
> Impact: cleanup
> 
> Signed-off-by: Alex Chiang <achiang@hp.com>
> ---
> This is obviously (to me) .30 material, thanks.

.29 material even - applied to tip:x86/urgent, thanks Alex. Sloppy printouts 
attract sloppy users which is a bad deal ;-)

	Ingo
