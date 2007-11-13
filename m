Return-Path: <linux-kernel-owner+w=401wt.eu-S1762838AbXKMXE7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762838AbXKMXE7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 18:04:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755950AbXKMXEv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 18:04:51 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:48830 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752118AbXKMXEu (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 18:04:50 -0500
Date: Wed, 14 Nov 2007 10:04:45 +1100
From: David Chinner <dgc@sgi.com>
To: linux-kernel@vger.kernel.org
Subject: Re: XFS related Oops
Message-ID: <20071113230445.GE995458@sgi.com>
References: <20071112064706.GA23595@dose.home.local> <20071112222720.GG995458@sgi.com> <20071113105119.GA11527@dose.home.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071113105119.GA11527@dose.home.local>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2007 at 11:51:19AM +0100, Tino Keitel wrote:
> On Tue, Nov 13, 2007 at 09:27:20 +1100, David Chinner wrote:
> 
> [...]
> 
> > No. I'd say something got screwed up during suspend/resume. Is it
> > reproducable?
> 
> No. I often use suspend to RAM, and usually it works without such
> failures. I restart squid during the resume prosecure, and the above
> Oops lead to a squid in D state.

Ok. Sounds like there's not much we can debug at this point. Thanks
for the report, though.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
