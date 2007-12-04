Return-Path: <linux-kernel-owner+w=401wt.eu-S1753958AbXLDMUk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958AbXLDMUk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 07:20:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752615AbXLDMUb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 07:20:31 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58723 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752608AbXLDMUa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 07:20:30 -0500
Date: Tue, 4 Dec 2007 13:20:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Kyle McMartin <kyle@mcmartin.ca>, LKML <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org, Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Matthew Wilcox <willy@debian.org>
Subject: Re: [BUG] 2.6.24-rc3-git2 softlockup detected
Message-ID: <20071204122005.GA27286@elte.hu>
References: <474D0AAC.5010005@linux.vnet.ibm.com> <20071127225328.9e3f3827.akpm@linux-foundation.org> <474D15FF.5080508@linux.vnet.ibm.com> <20071127232552.ad16e95c.akpm@linux-foundation.org> <474E5CAC.9000108@linux.vnet.ibm.com> <20071129003533.54b4b20e.akpm@linux-foundation.org> <20071130063929.GD2754@fattire.cabal.ca> <20071129230047.1b482562.akpm@linux-foundation.org> <20071129230204.8698f47e.akpm@linux-foundation.org> <474FBB86.5000004@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <474FBB86.5000004@linux.vnet.ibm.com>
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


* Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:

> > So 2.6.24-rc3 was OK and 2.6.24-rc3-git2 is not?
> 
> Yes, the 2.6.24-rc3 was Ok and this is seen from 2.6.24-rc3-git2/3/4.

just to make sure: this is a real lockup and failed bootup (or device 
init), not just a message, right?

	Ingo
