Return-Path: <linux-kernel-owner+w=401wt.eu-S1755979AbZD2XFf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755979AbZD2XFf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 19:05:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751099AbZD2XF0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 19:05:26 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:33741 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752631AbZD2XFZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 19:05:25 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18936.56613.479043.380867@cargo.ozlabs.ibm.com>
Date: Thu, 30 Apr 2009 09:05:09 +1000
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Robert Richter <robert.richter@amd.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf_counter: powerpc: allow use of limited-function
	counters
In-Reply-To: <20090429130915.GA23563@elte.hu>
References: <18936.19035.163066.892208@cargo.ozlabs.ibm.com>
	<20090429130915.GA23563@elte.hu>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:

> [ Note, i saw some fuzz in those files. It applied fine but maybe 
>   you have some local changes in them that are not in 
>   tip:perfcounters/core yet? You might want to double check that. ]

I think it was just Robert Richter's changes that caused the fuzz.
The end result seems to be OK.

Paul.
