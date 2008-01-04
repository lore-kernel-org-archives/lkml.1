Return-Path: <linux-kernel-owner+w=401wt.eu-S1757933AbYADJTt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757933AbYADJTt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 04:19:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754687AbYADJTk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 04:19:40 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56083 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754613AbYADJTj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 04:19:39 -0500
Date: Fri, 4 Jan 2008 10:19:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@suse.de>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH x86] [13/16] i386: Set CFQ as default in i386 defconfig
Message-ID: <20080104091925.GJ28740@elte.hu>
References: <20080103442.621670000@suse.de> <20080103154227.784F114DDB@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080103154227.784F114DDB@wotan.suse.de>
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


* Andi Kleen <ak@suse.de> wrote:

> Someone complained that the i386 defconfig contains AS as default IO 
> scheduler. Change that to CFQ.

thanks, applied.

	Ingo
