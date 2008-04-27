Return-Path: <linux-kernel-owner+w=401wt.eu-S1760890AbYD0C6Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760890AbYD0C6Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 22:58:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753694AbYD0C6D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 22:58:03 -0400
Received: from havoc.gtf.org ([69.61.125.42]:49363 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753620AbYD0C6C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 22:58:02 -0400
Date: Sat, 26 Apr 2008 22:58:00 -0400
From: Jeff Garzik <jeff@garzik.org>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, bunk@kernel.org, akpm@linux-foundation.org,
       harvey.harrison@gmail.com, mchehab@infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: If you want me to quit I will quit
Message-ID: <20080427025800.GD24710@havoc.gtf.org>
References: <20080426084420.8e61c379.akpm@linux-foundation.org> <20080426171604.GN2252@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0804261024580.2813@woody.linux-foundation.org> <20080426.173129.232382024.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080426.173129.232382024.davem@davemloft.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 26, 2008 at 05:31:29PM -0700, David Miller wrote:
> From: Linus Torvalds <torvalds@linux-foundation.org>
> Date: Sat, 26 Apr 2008 10:31:36 -0700 (PDT)
> 
> > And once you've publicized them, you don't know who has that tree, so just 
> > from a sanity and debugging standpoint, you should try to avoid mucking 
> > with already-public versions. If you made a mistake, add a patch on top to 
> > fix it (and announce the new state), but generally try to not "hide" the 
> > fact that the state has changed.
> 
> I didn't rebase at all this past cycle for networking, and it
> helped the people downstream from me _A LOT_.

The Downstream Collective thanks you!  ;-)

	Jeff



