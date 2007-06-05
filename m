Return-Path: <linux-kernel-owner+w=401wt.eu-S1763238AbXFEEiB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763238AbXFEEiB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 00:38:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754612AbXFEEhy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 00:37:54 -0400
Received: from ozlabs.org ([203.10.76.45]:41699 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753993AbXFEEhx (ORCPT <rfc822;Linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 00:37:53 -0400
Subject: Re: Interesting interaction between lguest and CFS
From: Rusty Russell <rusty@rustcorp.com.au>
To: Matt Mackall <mpm@selenic.com>
Cc: Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       Linux-kernel@vger.kernel.org
In-Reply-To: <20070605041803.GO11115@waste.org>
References: <20070604173710.GR11166@waste.org>
	 <1181002734.25878.56.camel@localhost.localdomain>
	 <1181010675.25878.140.camel@localhost.localdomain>
	 <20070605041803.GO11115@waste.org>
Content-Type: text/plain
Date: Tue, 05 Jun 2007 14:37:38 +1000
Message-Id: <1181018258.25878.150.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-06-04 at 23:18 -0500, Matt Mackall wrote:
> On Tue, Jun 05, 2007 at 12:31:15PM +1000, Rusty Russell wrote:
> > Does this solve it for you?
> 
> Nope. Doesn't accept input and hogs the CPU with lots of system time.

Dumb question: did you replace both the module and the launcher?

Rusty.


