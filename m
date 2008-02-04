Return-Path: <linux-kernel-owner+w=401wt.eu-S1755506AbYBDM14@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506AbYBDM14 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 07:27:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754420AbYBDM1q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 07:27:46 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46950 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752988AbYBDM1p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 07:27:45 -0500
Date: Mon, 4 Feb 2008 13:27:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Len Brown <lenb@kernel.org>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: 2.6.25-git: "x86: fix ioremap RAM check" causes - ACPI
	Error... Could not map memory
Message-ID: <20080204122724.GA31186@elte.hu>
References: <200802040228.39880.lenb@kernel.org> <200802041320.47495.rjw@sisk.pl> <20080204122505.GA30564@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080204122505.GA30564@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> > On Monday, 4 of February 2008, Len Brown wrote:
> > > My HP nx6325 started printing the ACPI Error's below starting at 
> > > the commit below.
> > 
> > Mine too.
> 
> does latest x86.git#mm fix it?

access coordinates:

  http://people.redhat.com/mingo/x86.git/README

	Ingo
