Return-Path: <linux-kernel-owner+w=401wt.eu-S1755372AbXJ2UKB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372AbXJ2UKB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 16:10:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751549AbXJ2UJx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 16:09:53 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:57998 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751415AbXJ2UJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 16:09:52 -0400
Date: Mon, 29 Oct 2007 13:09:51 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>, Greg KH <greg@kroah.com>,
       Dave Jones <davej@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Martin Ebourne <fedora@ebourne.me.uk>,
       Zou Nan hai <nanhai.zou@intel.com>, Andi Kleen <ak@suse.de>,
       stable@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Andy Whitcroft <apw@shadowen.org>, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [stable] 2.6.23 boot failures on x86-64.
In-Reply-To: <20071029195249.GA21225@linux-os.sc.intel.com>
Message-ID: <Pine.LNX.4.64.0710291309350.1379@schroedinger.engr.sgi.com>
References: <20071029175014.GH7793@redhat.com> <20071029180739.GA17595@kroah.com>
 <alpine.LFD.0.999.0710291123200.30120@woody.linux-foundation.org>
 <20071029195249.GA21225@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Oct 2007, Siddha, Suresh B wrote:

> But I can't explain how 2e1c49db4c640b35df13889b86b9d62215ade4b6 can be
> the root cause of Dave's issue in 2.6.23.

2.6.23 has no VMEMMAP support for x86_64.

