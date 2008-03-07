Return-Path: <linux-kernel-owner+w=401wt.eu-S933034AbYCGCda@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933034AbYCGCda (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 21:33:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759825AbYCGCdR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 21:33:17 -0500
Received: from mail.suse.de ([195.135.220.2]:53205 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759059AbYCGCdQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 21:33:16 -0500
Date: Fri, 7 Mar 2008 03:33:15 +0100
From: Nick Piggin <npiggin@suse.de>
To: Christoph Lameter <clameter@sgi.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       yanmin_zhang@linux.intel.com, David Miller <davem@davemloft.net>,
       Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [rfc][patch 1/3] slub: fix small HWCACHE_ALIGN alignment
Message-ID: <20080307023315.GE21185@wotan.suse.de>
References: <Pine.LNX.4.64.0803031331340.4375@schroedinger.engr.sgi.com> <47CC6F30.50802@cs.helsinki.fi> <20080305002821.GD1510@wotan.suse.de> <Pine.LNX.4.64.0803051254570.30742@schroedinger.engr.sgi.com> <20080306024904.GA27150@wotan.suse.de> <Pine.LNX.4.64.0803061451230.16212@schroedinger.engr.sgi.com> <20080307020443.GA21185@wotan.suse.de> <Pine.LNX.4.64.0803061816430.28976@schroedinger.engr.sgi.com> <20080307022537.GC21185@wotan.suse.de> <Pine.LNX.4.64.0803061827040.29527@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0803061827040.29527@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 06, 2008 at 06:27:12PM -0800, Christoph Lameter wrote:
> On Fri, 7 Mar 2008, Nick Piggin wrote:
> 
> > > Is that really a noteworthy effect?
> > 
> > Yes.
> 
> Numbers?

Uhh... big number > small number

