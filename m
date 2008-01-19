Return-Path: <linux-kernel-owner+w=401wt.eu-S1762560AbYASQ6g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762560AbYASQ6g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 11:58:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755881AbYASQ63
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 11:58:29 -0500
Received: from colo.lackof.org ([198.49.126.79]:32853 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755277AbYASQ62 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 11:58:28 -0500
Date: Sat, 19 Jan 2008 09:58:09 -0700
From: Grant Grundler <grundler@parisc-linux.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Greg KH <greg@kroah.com>, Loic Prylli <loic@myri.com>,
       Adrian Bunk <bunk@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
       linux-pci@atrey.karlin.mff.cuni.cz, Martin Mares <mj@ucw.cz>,
       Tony Camuso <tcamuso@redhat.com>
Subject: Re: [Patch v2] Make PCI extended config space (MMCONFIG) a driver
	opt-in
Message-ID: <20080119165809.GB11553@colo.lackof.org>
References: <20080112002638.GA18710@kroah.com> <20080112144030.GA19279@jurassic.park.msu.ru> <1200208085.6896.134.camel@pasglop> <20080113072415.GB18741@parisc-linux.org> <20080113090108.3224698c@laptopd505.fenrus.org> <20080114225225.GQ18741@parisc-linux.org> <20080114230448.GL9847@does.not.exist> <478CD8A5.5090608@myri.com> <20080115174643.GB28238@kroah.com> <20080115175641.GE18741@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080115175641.GE18741@parisc-linux.org>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2008 at 10:56:41AM -0700, Matthew Wilcox wrote:
> On Tue, Jan 15, 2008 at 09:46:43AM -0800, Greg KH wrote:
> > But so far, we have a zillion patches floating around, claiming
> > different things, some with signed-off-bys and others without, so for
> > now, I'll just stick with Arjan's patch in -mm and see if anyone
> > complains about those releases...
> 
> I complain about Arjan's patch.  For reasons which have been adequately
> gone into already in this thread.

Agreed.
Greg, I think at least two better alternatives were proposed already.
Please review the thread again.

grant
