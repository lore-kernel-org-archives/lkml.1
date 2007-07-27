Return-Path: <linux-kernel-owner+w=401wt.eu-S934978AbXG0HQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934978AbXG0HQX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 03:16:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934573AbXG0HQC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 03:16:02 -0400
Received: from gate.crashing.org ([63.228.1.57]:37266 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934476AbXG0HQA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 03:16:00 -0400
Subject: Re: [PATCH] powerpc: Pegasos keyboard detection
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alan Curry <pacman@theworld.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
In-Reply-To: <20070726212241.032e9755.akpm@linux-foundation.org>
References: <200707250128.l6P1SWSF1336935@shell01.TheWorld.com>
	 <1185347565.5439.310.camel@localhost.localdomain>
	 <20070726184800.0bb3b9fb.akpm@linux-foundation.org>
	 <1185505222.5495.182.camel@localhost.localdomain>
	 <20070726212241.032e9755.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 27 Jul 2007 17:15:47 +1000
Message-Id: <1185520547.5495.192.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-07-26 at 21:22 -0700, Andrew Morton wrote:
> 
> > Merged a fixed version:
> > 
> > f5d834fc34e61f1a40435981062000e5d2b2baa8
> > 
> > (In linus tree as of now)
> 
> I hope so.  Alan's patch looks rather different from what you have
> now:
> fall back to of_find_node_by_name() if of_find_node_by_type() failed.

Which is just waht that commit does :-)

Ben.


