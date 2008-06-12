Return-Path: <linux-kernel-owner+w=401wt.eu-S1759025AbYFLJQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759025AbYFLJQX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 05:16:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754213AbYFLJQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 05:16:14 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60586 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754025AbYFLJQN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 05:16:13 -0400
Date: Thu, 12 Jun 2008 11:15:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
       Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 1/4] x86: Remove obsolete PM definitions from NMI header
Message-ID: <20080612091532.GC15312@elte.hu>
References: <200806121025.24668.rjw@sisk.pl> <200806121027.09085.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806121027.09085.rjw@sisk.pl>
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


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> Remove obsolete and no longer used PM-related definitions from 
> include/asm-x86/nmi.h .
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

applied to tip/x86/cleanups, thanks Rafael.

	Ingo
