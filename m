Return-Path: <linux-kernel-owner+w=401wt.eu-S1758163AbYGaV13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758163AbYGaV13 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 17:27:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753987AbYGaV1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 17:27:21 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42988 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753976AbYGaV1U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 17:27:20 -0400
Date: Thu, 31 Jul 2008 23:27:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Oruba <peter.oruba@amd.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: [patch 0/4] x86: AMD microcode patch loading v2 fixes
Message-ID: <20080731212701.GG2729@elte.hu>
References: <20080729154103.007575982@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080729154103.007575982@amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Oruba <peter.oruba@amd.com> wrote:

> Fixed coding style issues.

applied to tip/x86/microcode - thanks Peter.

Will you take a shot at moving the driver to early init (and early SMP 
init) code, as suggested by Dmitry?

	Ingo
