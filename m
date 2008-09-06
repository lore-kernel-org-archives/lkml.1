Return-Path: <linux-kernel-owner+w=401wt.eu-S1753476AbYIFOfX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476AbYIFOfX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 10:35:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751959AbYIFOfK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 10:35:10 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46575 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751790AbYIFOfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 10:35:09 -0400
Date: Sat, 6 Sep 2008 16:34:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrey Borzenkov <arvidjaar@newmail.ru>
Cc: hpa@zytor.com, Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Ghost EDD devices in /sys again
Message-ID: <20080906143453.GA2328@elte.hu>
References: <200809052219.44093.arvidjaar@newmail.ru> <200809061240.25925.arvidjaar@newmail.ru> <20080906120720.GB30964@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080906120720.GB30964@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0034]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> looks good to me - applied it to tip/x86/urgent. Thanks Andrey!

ok - Peter says he'd rather like to investigate this some more and have 
the fix in v2.6.28 instead - so i moved it from tip/x86/urgent to 
tip/x86/setup.

	Ingo
