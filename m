Return-Path: <linux-kernel-owner+w=401wt.eu-S1759992AbYFQWvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759992AbYFQWvS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 18:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757634AbYFQWvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 18:51:08 -0400
Received: from ns2.suse.de ([195.135.220.15]:45335 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756271AbYFQWvH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 18:51:07 -0400
Date: Tue, 17 Jun 2008 15:48:56 -0700
From: Greg KH <gregkh@suse.de>
To: Daniel Barkalow <barkalow@iabervon.org>
Cc: Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
       arjan@linux.intel.com, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       tglx@linutronix.de, linville@tuxdriver.com, davej@redhat.com
Subject: Re: Oops report for the week preceding June 16th, 2008
Message-ID: <20080617224856.GA16933@suse.de>
References: <4856AFDF.5080901@linux.intel.com> <20080617092023.GA20621@elte.hu> <20080617.022652.76635616.davem@davemloft.net> <20080617153356.GA3510@elte.hu> <20080617175414.GA9866@suse.de> <alpine.LNX.1.00.0806171428320.19665@iabervon.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.00.0806171428320.19665@iabervon.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2008 at 02:43:02PM -0400, Daniel Barkalow wrote:
> 
> On the other hand, it would be good if there were a way to include 
> unstable APIs in the mainline kernel so that they could get some exposure 
> before they're set in stone, and that would also eliminate that reason for 
> keeping drivers out so long.

That's exactly what the documentation in Documentation/ABI is there for.
Document your "experimental" API, along with any userspace programs that
are using it, and work to try to finalize it.

thanks,

greg k-h
