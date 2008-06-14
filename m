Return-Path: <linux-kernel-owner+w=401wt.eu-S1758013AbYFNIcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758013AbYFNIcW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 04:32:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753938AbYFNIcN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 04:32:13 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44466 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753625AbYFNIcL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 04:32:11 -0400
Date: Sat, 14 Jun 2008 10:31:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Alexey Starikovskiy <aystarik@gmail.com>, webmaster@dragonslave.de,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: linux-next Regression: Unable to locate IOAPIC
Message-ID: <20080614083159.GA29894@elte.hu>
References: <200806051100.12885.dex@dragonslave.de> <200806102229.10512.dex@dragonslave.de> <4851AA24.7060906@gmail.com> <200806131307.39807.dex@dragonslave.de> <48536E3B.4000703@gmail.com> <86802c440806140126l7a949783of0fb08d11ae07bef@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440806140126l7a949783of0fb08d11ae07bef@mail.gmail.com>
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


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> can you check if the attached patch fix the problem?
> it will not check entries before MP_intsrc_info...

applied to tip/x86/mpparse for more testing.

	Ingo
