Return-Path: <linux-kernel-owner+w=401wt.eu-S932251AbZDBSjX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932251AbZDBSjX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 14:39:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754975AbZDBSjC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 14:39:02 -0400
Received: from hera.kernel.org ([140.211.167.34]:42493 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754329AbZDBSjA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 14:39:00 -0400
Subject: Re: [tip:perfcounters/core] perf_counter: kerneltop: update to new
 ABI
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       linux-tip-commits@vger.kernel.org
In-Reply-To: <20090402182833.GA32407@elte.hu>
References: <20090402091319.407283141@chello.nl>
	 <tip-373b153677f26a263ef297d77a5e045a31f6486c@git.kernel.org>
	 <1238679305.3099.11.camel@ht.satnam> <1238680772.3099.13.camel@ht.satnam>
	 <20090402181144.GB6340@elte.hu> <1238696579.3099.50.camel@ht.satnam>
	 <20090402182833.GA32407@elte.hu>
Content-Type: text/plain
Date: Fri, 03 Apr 2009 00:08:05 +0530
Message-Id: <1238697485.3099.58.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-04-02 at 20:28 +0200, Ingo Molnar wrote:

> That is not what i suggested though. I suggested '-e 1' to mean to 
> default to the more common case: hw counters. I.e.:
> 
>  -e 1    ==    -e 0:1
>  -e 2    ==    -e 0:2
>  -e 3    ==    -e 0:3
>  ...
> 
> sw counters could be specified only via the longer form.
> 

If someone want to see all supported event counters. Then what is your
suggestion, can we represent some shortcut for it.

--
JSR

