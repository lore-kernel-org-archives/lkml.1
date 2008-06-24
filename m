Return-Path: <linux-kernel-owner+w=401wt.eu-S1759593AbYFXKxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759593AbYFXKxv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 06:53:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752190AbYFXKxl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 06:53:41 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58889 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750997AbYFXKxl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 06:53:41 -0400
Date: Tue, 24 Jun 2008 12:53:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: setup_arch 32bit move kvm_guest_init later
Message-ID: <20080624105326.GA12384@elte.hu>
References: <200806231951.10898.yhlu.kernel@gmail.com> <200806231953.33437.yhlu.kernel@gmail.com> <200806231954.23694.yhlu.kernel@gmail.com> <200806231955.05921.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806231955.05921.yhlu.kernel@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0007]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

applied all 9 patches to tip/x86/setup-memory. Thanks Yinghai,

	Ingo
