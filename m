Return-Path: <linux-kernel-owner+w=401wt.eu-S1764052AbXKOAYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764052AbXKOAYR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 19:24:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753804AbXKOAYG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 19:24:06 -0500
Received: from ozlabs.org ([203.10.76.45]:36180 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753363AbXKOAYF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 19:24:05 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18235.37249.823703.12168@cargo.ozlabs.ibm.com>
Date: Thu, 15 Nov 2007 11:23:29 +1100
From: Paul Mackerras <paulus@samba.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Stephane Eranian <eranian@hpl.hp.com>,
       Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Philip Mucci <mucci@cs.utk.edu>, William Cohen <wcohen@redhat.com>,
       Robert Richter <robert.richter@amd.com>, linux-kernel@vger.kernel.org,
       Perfmon <perfmon@napali.hpl.hp.com>,
       perfmon2-devel@lists.sourceforge.net,
       OSPAT devel <ospat-devel@cs.utk.edu>,
       papi list <ptools-perfapi@cs.utk.edu>
Subject: Re: [perfmon] Re: [perfmon2] perfmon2 merge news
In-Reply-To: <20071114142629.GE17145@one.firstfloor.org>
References: <20071113175545.GD4319@frankl.hpl.hp.com>
	<53F4663B-CFBA-44E4-8283-BAAC8C8F1AFF@cs.utk.edu>
	<20071113185924.GA22748@suse.de>
	<20071113120728.4342e7d7.akpm@linux-foundation.org>
	<18234.41652.199520.31261@cargo.ozlabs.ibm.com>
	<20071114103805.GA16652@infradead.org>
	<18234.53558.883970.87414@cargo.ozlabs.ibm.com>
	<20071114110009.GA17833@infradead.org>
	<p734pfp6lyp.fsf@bingen.suse.de>
	<20071114141342.GH6557@frankl.hpl.hp.com>
	<20071114142629.GE17145@one.firstfloor.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen writes:

> > This only works when counting (not sampling) and only for self-monitoring.
> 
> It works for global monitoring too.

How would you provide access to the counters of another process?
Through an extension to ptrace perhaps?

Paul.
