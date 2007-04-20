Return-Path: <linux-kernel-owner+w=401wt.eu-S2993273AbXDTQUM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993273AbXDTQUM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 12:20:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993274AbXDTQUM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 12:20:12 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:32864 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S2993273AbXDTQUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 12:20:10 -0400
Date: Fri, 20 Apr 2007 11:20:02 -0500
From: Robin Holt <holt@sgi.com>
To: Andi Kleen <ak@suse.de>, Keith Owens <kaos@sgi.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, piet@bluelane.com,
       Tom Rini <trini@kernel.crashing.org>, Dave Jiang <djiang@mvista.com>,
       linux-kernel@vger.kernel.org, sshtylyov@ru.mvista.com,
       Andrew Morton <akpm@osdl.org>,
       George Anzinger <george@wildturkeyranch.net>,
       "David O'Brien" <obrien@freebsd.org>
Subject: Re: Permanent Kgdb integration into the kernel - lets get with it.
Message-ID: <20070420162002.GB20026@lnx-holt.americas.sgi.com>
References: <20070307204516.GA24095@blade.az.mvista.com> <1173392650.8912.236.camel@piet2.bluelane.com> <20070417113016.1f0812c7.randy.dunlap@oracle.com> <200704172045.03743.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704172045.03743.ak@suse.de>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2007 at 08:45:03PM +0200, Andi Kleen wrote:
> 
> > Is there any movement on this?
> 
> I'm open to reasonable patches for the hooks at least. If that is done
> then the actual kgdb code can be reviewed and considered eventually too. 

Would you be open to adding to that set of hooks the ones needed to get
KDB working as a loadable module?  Keith, would that be possible?

Thanks,
Robin
