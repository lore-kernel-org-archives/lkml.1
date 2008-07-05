Return-Path: <linux-kernel-owner+w=401wt.eu-S1753507AbYGEGoj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507AbYGEGoj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 02:44:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751903AbYGEGob
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 02:44:31 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60792 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750898AbYGEGoa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 02:44:30 -0400
Date: Sat, 5 Jul 2008 08:44:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "R. J. Wysocki" <Rafal.Wysocki@fuw.edu.pl>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Dionisus Torimens <djtm@gmx.net>
Subject: Re: [PATCH] x86 ACPI: Fix resume from suspend to RAM on
	uniprocessor x86-64
Message-ID: <20080705064404.GB12991@elte.hu>
References: <200807050005.31272.rjw@sisk.pl> <200807050008.30497.Rafal.Wysocki@fuw.edu.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807050008.30497.Rafal.Wysocki@fuw.edu.pl>
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


* R. J. Wysocki <Rafal.Wysocki@fuw.edu.pl> wrote:

> On Saturday, 5 of July 2008, Rafael J. Wysocki wrote:
> > Hi Ingo,
> > 
> > This is a regression fix, please push to Linus ASAP.

> Reported-by: Dionisus Torimens <djtm@gmx.net>

applied to tip/x86/urgent - thanks Rafael. I also queued up Peter's "x86 
ACPI: normalize segment descriptor register on resume" fix.

	Ingo
