Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031Ab0BIEYH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 23:24:07 -0500
Received: from ozlabs.org ([203.10.76.45]:41065 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752295Ab0BIEYD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 23:24:03 -0500
Date: Tue, 9 Feb 2010 15:23:48 +1100
From: Paul Mackerras <paulus@samba.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Stephane Eranian <eranian@google.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Don Zickus <dzickus@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC perf,x86] P4 PMU early draft
Message-ID: <20100209042348.GA2558@brick.ozlabs.ibm.com>
References: <20100208184504.GB5130@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100208184504.GB5130@lenovo>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 08, 2010 at 09:45:04PM +0300, Cyrill Gorcunov wrote:

> The main problem in implementing P4 PMU is that it has much more
> restrictions for event to MSR mapping. So to fit into current
> perf_events model I made the following:

Is there somewhere accessible on the web where I can read about the P4
PMU?  I'm interested to see if the constraint representation and
search I used on the POWER processors would be applicable.

Paul.
