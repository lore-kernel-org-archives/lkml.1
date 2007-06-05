Return-Path: <linux-kernel-owner+w=401wt.eu-S1755030AbXFEESe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755030AbXFEESe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 00:18:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754475AbXFEES0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 00:18:26 -0400
Received: from waste.org ([66.93.16.53]:56923 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753931AbXFEESZ (ORCPT <rfc822;Linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 00:18:25 -0400
Date: Mon, 4 Jun 2007 23:18:03 -0500
From: Matt Mackall <mpm@selenic.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       Linux-kernel@vger.kernel.org
Subject: Re: Interesting interaction between lguest and CFS
Message-ID: <20070605041803.GO11115@waste.org>
References: <20070604173710.GR11166@waste.org> <1181002734.25878.56.camel@localhost.localdomain> <1181010675.25878.140.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1181010675.25878.140.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 05, 2007 at 12:31:15PM +1000, Rusty Russell wrote:
> Does this solve it for you?

Nope. Doesn't accept input and hogs the CPU with lots of system time.

-- 
Mathematics is the supreme nostalgia of our time.
