Return-Path: <linux-kernel-owner+w=401wt.eu-S1753415AbZI2SXy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415AbZI2SXy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 14:23:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752594AbZI2SXx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 14:23:53 -0400
Received: from sous-sol.org ([216.99.217.87]:38358 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750952AbZI2SXx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 14:23:53 -0400
Date: Tue, 29 Sep 2009 11:21:06 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Alok Kataria <akataria@vmware.com>
Cc: Chris Wright <chrisw@sous-sol.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Gerd Hoffmann <kraxel@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
       Greg KH <greg@kroah.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Paravirtualization on VMware's Platform [VMI].
Message-ID: <20090929182106.GE3958@sequoia.sous-sol.org>
References: <20090919224430.GB9567@kroah.com> <1253419185.3253.21.camel@ank32.eng.vmware.com> <20090920074247.GA5733@elte.hu> <1253647845.10565.20.camel@ank32.eng.vmware.com> <4AB9CE66.1030504@redhat.com> <1254185107.13456.32.camel@ank32.eng.vmware.com> <4AC17018.4040600@zytor.com> <1254193238.13456.48.camel@ank32.eng.vmware.com> <20090929090130.GD3958@sequoia.sous-sol.org> <1254245124.7803.34.camel@ank32.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1254245124.7803.34.camel@ank32.eng.vmware.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Alok Kataria (akataria@vmware.com) wrote:
> Mark VMI for removal in feature-removal-schedule.txt.
> 
> From: Alok N Kataria <akataria@vmware.com>
> 
> Add text in feature-removal.txt and also modify Kconfig to disable
> vmi by default.
> 
> Signed-off-by: Alok N Kataria <akataria@vmware.com>

Acked-by: Chris Wright <chrisw@sous-sol.org>
