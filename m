Return-Path: <linux-kernel-owner+w=401wt.eu-S934105AbZJMTVr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934105AbZJMTVr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 15:21:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753873AbZJMTVr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 15:21:47 -0400
Received: from vena.lwn.net ([206.168.112.25]:44578 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753852AbZJMTVq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 15:21:46 -0400
Date: Tue, 13 Oct 2009 13:21:08 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: mgross@linux.intel.com
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Vincent Sanders <vince@simtec.co.uk>, John Kacur <jkacur@redhat.com>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 01/28] pm_qos: remove BKL
Message-ID: <20091013132108.6528b56a@bike.lwn.net>
In-Reply-To: <20091013191218.GA5197@linux.intel.com>
References: <20091010153314.827301943@linutronix.de>
	<20091010153349.071381158@linutronix.de>
	<20091013191218.GA5197@linux.intel.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Oct 2009 12:12:18 -0700
mgross <mgross@linux.intel.com> wrote:

> I thought we made this change a month or 3 ago.
> 
> Signed-off-by: Mark Gross <mgross@linux.intel.com>

Change went out but it was caught snoozing during the 2.6.32 merge
window.

I think you really want "Acked-by", no?

Thanks,

jon
