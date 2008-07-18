Return-Path: <linux-kernel-owner+w=401wt.eu-S1758237AbYGRQWA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758237AbYGRQWA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 12:22:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755101AbYGRQVw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 12:21:52 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50850 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752681AbYGRQVv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 12:21:51 -0400
Date: Fri, 18 Jul 2008 18:21:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: yhlu.kernel@gmail.com, tglx@linutronix.de, hpa@zytor.com,
       kernel-janitors@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86 setup.c: cleanup includes
Message-ID: <20080718162137.GZ6875@elte.hu>
References: <a4423d670807060913red9187bj7bcc886d1fb20ad3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4423d670807060913red9187bj7bcc886d1fb20ad3@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0062]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexander Beregalov <a.beregalov@gmail.com> wrote:

> From: Alexander Beregalov <a.beregalov@gmail.com>
> 
> The patch applies to the linux-next tree.
> 
> x86: remove double includes in setup.c

applied to tip/x86/cleanups - thanks Alexander.

	Ingo
