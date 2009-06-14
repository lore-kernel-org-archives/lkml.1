Return-Path: <linux-kernel-owner+w=401wt.eu-S1757769AbZFNPBn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757769AbZFNPBn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 11:01:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756603AbZFNPBd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 11:01:33 -0400
Received: from mail.gmx.net ([213.165.64.20]:40796 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756159AbZFNPBc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 11:01:32 -0400
X-Authenticated: #3576790
X-Provags-ID: V01U2FsdGVkX196SuNXG9h6Sjmcl1QAXmbwXq0pnbFwKHc5uk5jYa
	wC4IVynnSejBTi
Date: Sun, 14 Jun 2009 17:03:34 +0200
From: "Benjamin S." <sbenni@gmx.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, "js@sig21.net" <js@sig21.net>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Linux PCI <linux-pci@vger.kernel.org>, Matthew Wilcox <matthew@wil.cx>
Subject: Re: 2.6.30 enabling cpu1 on resume fails after suspend to memory
Message-ID: <20090614170334.3fcfb2ee@pluto-lenny.milky.way>
In-Reply-To: <alpine.LFD.2.00.0906141644190.2800@localhost.localdomain>
References: <20090614120950.116536fa@pluto-lenny.milky.way>
	<200906141400.27331.rjw@sisk.pl>
	<alpine.LFD.2.00.0906141405450.2800@localhost.localdomain>
	<200906141415.16949.rjw@sisk.pl>
	<20090614143708.32ec250c@pluto-lenny.milky.way>
	<alpine.LFD.2.00.0906141444500.2800@localhost.localdomain>
	<7E82351C108FA840AB1866AC776AEC4669244187@orsmsx505.amr.corp.intel.com>
	<alpine.LFD.2.00.0906141514120.2800@localhost.localdomain>
	<7E82351C108FA840AB1866AC776AEC466924418A@orsmsx505.amr.corp.intel.com>
	<alpine.LFD.2.00.0906141548490.2800@localhost.localdomain>
	<alpine.LFD.2.00.0906141644190.2800@localhost.localdomain>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.74
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Jun 2009 16:45:10 +0200 (CEST)
Thomas Gleixner <tglx@linutronix.de> wrote:

> can you please test the patch below.

It works. 


Benjamin
