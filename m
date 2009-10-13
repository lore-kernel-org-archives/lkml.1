Return-Path: <linux-kernel-owner+w=401wt.eu-S1761177AbZJMTwE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761177AbZJMTwE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 15:52:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754606AbZJMTwD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 15:52:03 -0400
Received: from mga09.intel.com ([134.134.136.24]:54072 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754059AbZJMTwC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 15:52:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,552,1249282800"; 
   d="scan'208";a="457116496"
Date: Tue, 13 Oct 2009 12:50:55 -0700
From: mgross <mgross@linux.intel.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Vincent Sanders <vince@simtec.co.uk>, John Kacur <jkacur@redhat.com>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 01/28] pm_qos: remove BKL
Message-ID: <20091013195055.GA10270@linux.intel.com>
Reply-To: mgross@linux.intel.com
References: <20091010153314.827301943@linutronix.de> <20091010153349.071381158@linutronix.de> <20091013191218.GA5197@linux.intel.com> <20091013132108.6528b56a@bike.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091013132108.6528b56a@bike.lwn.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 13, 2009 at 01:21:08PM -0600, Jonathan Corbet wrote:
> On Tue, 13 Oct 2009 12:12:18 -0700
> mgross <mgross@linux.intel.com> wrote:
> 
> > I thought we made this change a month or 3 ago.
> > 
> > Signed-off-by: Mark Gross <mgross@linux.intel.com>
> 
> Change went out but it was caught snoozing during the 2.6.32 merge
> window.
> 
> I think you really want "Acked-by", no?

Yes.  Sorry.

--mgross

> 
> Thanks,
> 
> jon
