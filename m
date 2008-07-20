Return-Path: <linux-kernel-owner+w=401wt.eu-S1756088AbYGTGp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756088AbYGTGp0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 02:45:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752079AbYGTGpM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 02:45:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50076 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751767AbYGTGpL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 02:45:11 -0400
Date: Sun, 20 Jul 2008 08:44:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       jbarnes@virtuousgeek.org, Jack Howarth <howarth@bromo.msbb.uc.edu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86,pci: detect end_bus_number according to acpi/e820
	reserved - fix
Message-ID: <20080720064458.GA13492@elte.hu>
References: <200807180941.09779.yhlu.kernel@gmail.com> <200807181322.37500.yhlu.kernel@gmail.com> <200807190216.32479.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807190216.32479.yhlu.kernel@gmail.com>
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

> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

applied to tip/pci-for-jesse and folded into "x86, pci: detect 
end_bus_number according to acpi/e820 reserved", thanks Yinghai.

	Ingo
