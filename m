Return-Path: <linux-kernel-owner+w=401wt.eu-S1761531AbZFNPmr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761531AbZFNPmr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 11:42:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752669AbZFNPmj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 11:42:39 -0400
Received: from www.tglx.de ([62.245.132.106]:33644 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752344AbZFNPmi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 11:42:38 -0400
Date: Sun, 14 Jun 2009 17:41:50 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Benjamin S." <sbenni@gmx.de>
cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, "js@sig21.net" <js@sig21.net>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Linux PCI <linux-pci@vger.kernel.org>, Matthew Wilcox <matthew@wil.cx>
Subject: Re: 2.6.30 enabling cpu1 on resume fails after suspend to memory
In-Reply-To: <20090614170334.3fcfb2ee@pluto-lenny.milky.way>
Message-ID: <alpine.LFD.2.00.0906141741180.2800@localhost.localdomain>
References: <20090614120950.116536fa@pluto-lenny.milky.way> <200906141400.27331.rjw@sisk.pl> <alpine.LFD.2.00.0906141405450.2800@localhost.localdomain> <200906141415.16949.rjw@sisk.pl> <20090614143708.32ec250c@pluto-lenny.milky.way>
 <alpine.LFD.2.00.0906141444500.2800@localhost.localdomain> <7E82351C108FA840AB1866AC776AEC4669244187@orsmsx505.amr.corp.intel.com> <alpine.LFD.2.00.0906141514120.2800@localhost.localdomain> <7E82351C108FA840AB1866AC776AEC466924418A@orsmsx505.amr.corp.intel.com>
 <alpine.LFD.2.00.0906141548490.2800@localhost.localdomain> <alpine.LFD.2.00.0906141644190.2800@localhost.localdomain> <20090614170334.3fcfb2ee@pluto-lenny.milky.way>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Jun 2009, Benjamin S. wrote:

> On Sun, 14 Jun 2009 16:45:10 +0200 (CEST)
> Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > can you please test the patch below.
> 
> It works. 

I queue it up. Thanks,

  	tglx
