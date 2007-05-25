Return-Path: <linux-kernel-owner+w=401wt.eu-S932160AbXEYVrE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932160AbXEYVrE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 17:47:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763340AbXEYVqn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 17:46:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43161 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762666AbXEYVql (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 17:46:41 -0400
Date: Fri, 25 May 2007 14:31:11 -0700
From: Greg KH <gregkh@suse.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Jay Cliburn <jacliburn@bellsouth.net>,
       Grzegorz Krzystek <ninex@NineX.eu.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       ninex@o2.pl, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz,
       Michael Ellerman <michael@ellerman.id.au>,
       David Miller <davem@davemloft.net>, Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH 1/2] msi: Invert the sense of the MSI enables.
Message-ID: <20070525213111.GA6810@suse.de>
References: <20070515212200.517fcba2@osprey.hogchain.net> <m14pmcmz8r.fsf@ebiederm.dsl.xmission.com> <20070516185225.3f3ac082@osprey.hogchain.net> <m1sl9wl28m.fsf@ebiederm.dsl.xmission.com> <20070522204103.134bf5a2@osprey.hogchain.net> <m1veehcz7m.fsf_-_@ebiederm.dsl.xmission.com> <20070525052032.GB9386@suse.de> <m1myztaq5s.fsf@ebiederm.dsl.xmission.com> <20070525203501.GD5413@suse.de> <m1k5uwaa0h.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1k5uwaa0h.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 25, 2007 at 03:06:22PM -0600, Eric W. Biederman wrote:
> Greg KH <gregkh@suse.de> writes:
> > It's a trade off, and I'd like to choose the one that over the long
> > term, causes the least ammount of work and maintaiblity.  I think the
> > current blacklist meets that goal.
> 
> A reasonable goal.  I will come back to this after the long holiday
> weekend here and see what makes sense.

Ok, if you still think after looking into it some more that it's still
needed, please resend the patches, and I'll reconsider it.

thanks,

greg k-h
