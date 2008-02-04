Return-Path: <linux-kernel-owner+w=401wt.eu-S1755133AbYBDMZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755133AbYBDMZj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 07:25:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753306AbYBDMZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 07:25:31 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34109 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752350AbYBDMZa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 07:25:30 -0500
Date: Mon, 4 Feb 2008 13:25:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Len Brown <lenb@kernel.org>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: 2.6.25-git: "x86: fix ioremap RAM check" causes - ACPI
	Error... Could not map memory
Message-ID: <20080204122505.GA30564@elte.hu>
References: <200802040228.39880.lenb@kernel.org> <200802041320.47495.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802041320.47495.rjw@sisk.pl>
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


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> On Monday, 4 of February 2008, Len Brown wrote:
> > My HP nx6325 started printing the ACPI Error's below starting at the commit below.
> 
> Mine too.

does latest x86.git#mm fix it?

	Ingo
