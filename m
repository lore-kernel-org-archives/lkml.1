Return-Path: <linux-kernel-owner+w=401wt.eu-S1756971AbZCLXie@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756971AbZCLXie (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 19:38:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751660AbZCLXi0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 19:38:26 -0400
Received: from one.firstfloor.org ([213.235.205.2]:57780 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbZCLXi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 19:38:26 -0400
Date: Fri, 13 Mar 2009 00:38:22 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Daniel Phillips <phillips@phunq.net>
Cc: tux3@tux3.org, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [Tux3] Tux3 report: Tux3 Git tree available
Message-ID: <20090312233822.GK11935@one.firstfloor.org>
References: <200903110925.37614.phillips@phunq.net> <20090311230713.d4710050.akpm@linux-foundation.org> <87zlfqeuwr.fsf@basil.nowhere.org> <200903121424.08961.phillips@phunq.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903121424.08961.phillips@phunq.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 12, 2009 at 02:24:08PM -0700, Daniel Phillips wrote:
> On Thursday 12 March 2009, Andi Kleen wrote:
> > to be honest the estimate of adding btree directories in 3kLOC
> > of code seems very optimistic.
> 
> Is that a bet?

No, just a general comment comparing with other read/write btree
implementations.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
