Return-Path: <linux-kernel-owner+w=401wt.eu-S1758550AbZFONNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758550AbZFONNS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 09:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751331AbZFONNI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 09:13:08 -0400
Received: from bar.sig21.net ([80.81.252.164]:52203 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751181AbZFONNH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 09:13:07 -0400
Date: Mon, 15 Jun 2009 15:12:40 +0200
From: Johannes Stezenbach <js@sig21.net>
To: "Benjamin S." <sbenni@gmx.de>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Linux PCI <linux-pci@vger.kernel.org>, Matthew Wilcox <matthew@wil.cx>
Subject: Re: 2.6.30 enabling cpu1 on resume fails after suspend to memory
Message-ID: <20090615131240.GA4917@sig21.net>
References: <alpine.LFD.2.00.0906141405450.2800@localhost.localdomain> <200906141415.16949.rjw@sisk.pl> <20090614143708.32ec250c@pluto-lenny.milky.way> <alpine.LFD.2.00.0906141444500.2800@localhost.localdomain> <7E82351C108FA840AB1866AC776AEC4669244187@orsmsx505.amr.corp.intel.com> <alpine.LFD.2.00.0906141514120.2800@localhost.localdomain> <7E82351C108FA840AB1866AC776AEC466924418A@orsmsx505.amr.corp.intel.com> <alpine.LFD.2.00.0906141548490.2800@localhost.localdomain> <alpine.LFD.2.00.0906141644190.2800@localhost.localdomain> <20090614170334.3fcfb2ee@pluto-lenny.milky.way>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090614170334.3fcfb2ee@pluto-lenny.milky.way>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Spam-21-Score: -3.2 (---)
X-Spam-21-Report: No, score=-3.2 required=5.0 tests=ALL_TRUSTED=-1.8,AWL=1.149,BAYES_00=-2.599 autolearn=no
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 14, 2009 at 05:03:34PM +0200, Benjamin S. wrote:
> On Sun, 14 Jun 2009 16:45:10 +0200 (CEST)
> Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > can you please test the patch below.
> 
> It works. 

I can report that it works for me, too.

Thank you for fixing this while I was away.


Johannes
