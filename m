Return-Path: <linux-kernel-owner+w=401wt.eu-S1761249AbXFAM0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761249AbXFAM0b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 08:26:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759404AbXFAM0X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 08:26:23 -0400
Received: from ns1.suse.de ([195.135.220.2]:57622 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758955AbXFAM0X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 08:26:23 -0400
Date: Fri, 1 Jun 2007 14:26:14 +0200
From: Bernhard Walle <bwalle@suse.de>
To: Vivek Goyal <vgoyal@in.ibm.com>, Andi Kleen <ak@suse.de>,
       kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] x86_64: Reflect the relocatability of the kernel in the ELF header.
Message-ID: <20070601122614.GA4651@suse.de>
Mail-Followup-To: Vivek Goyal <vgoyal@in.ibm.com>,
	Andi Kleen <ak@suse.de>, kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org
References: <m1slah6gm0.fsf@ebiederm.dsl.xmission.com> <200704301717.08230.ak@suse.de> <20070501035539.GA15472@in.ibm.com> <m14pmx18ey.fsf@ebiederm.dsl.xmission.com> <20070501050657.GA23111@in.ibm.com> <20070528105442.GA25599@suse.de> <20070528110944.GE32045@in.ibm.com> <20070528143939.GA16026@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070528143939.GA16026@suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Bernhard Walle <bwalle@suse.de> [2007-05-28 16:39]:
> * Vivek Goyal <vgoyal@in.ibm.com> [2007-05-28 13:09]:
> > On Mon, May 28, 2007 at 12:54:42PM +0200, Bernhard Walle wrote:
> > > * Vivek Goyal <vgoyal@in.ibm.com> [2007-05-01 07:06]:
> > > > This seems to be a problem with gdb 6.5. I transferred the dump to a
> > > > different machine having GNU gdb 6.4, and it works fine there.
> > > 
> > > What's the state of it? Andy, was the GDB breakage the reason why you
> > > didn't merge it? Did someone file a GDB bug?
> > 
> > I had sent a mail to gdb mailing list but no response. Did not raise
> > a bug though.
> 
> BTW: Did anyone test with GDB 6.6?

/me. But I get the same error as with GDB 6.5. I'm looking if I can
find the cause of the problem.


Thanks,
   Bernhard
