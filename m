Return-Path: <linux-kernel-owner+w=401wt.eu-S1754501AbYA1Sdv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501AbYA1Sdv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 13:33:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752628AbYA1Sdl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 13:33:41 -0500
Received: from mx1.redhat.com ([66.187.233.31]:34482 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752422AbYA1Sdk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 13:33:40 -0500
Message-ID: <479E1FA6.1030708@redhat.com>
Date: Mon, 28 Jan 2008 13:32:06 -0500
From: Tony Camuso <tcamuso@redhat.com>
Reply-To: tcamuso@redhat.com
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Grant Grundler <grundler@parisc-linux.org>
CC: Matthew Wilcox <matthew@wil.cx>, Greg KH <greg@kroah.com>,
       Loic Prylli <loic@myri.com>, Adrian Bunk <bunk@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
       linux-pci@atrey.karlin.mff.cuni.cz, Martin Mares <mj@ucw.cz>
Subject: Re: [Patch v2] Make PCI extended config space (MMCONFIG) a driver
 opt-in
References: <20080112002638.GA18710@kroah.com> <20080112144030.GA19279@jurassic.park.msu.ru> <1200208085.6896.134.camel@pasglop> <20080113072415.GB18741@parisc-linux.org> <20080113090108.3224698c@laptopd505.fenrus.org> <20080114225225.GQ18741@parisc-linux.org> <20080114230448.GL9847@does.not.exist> <478CD8A5.5090608@myri.com> <20080115174643.GB28238@kroah.com> <20080115175641.GE18741@parisc-linux.org> <20080119165809.GB11553@colo.lackof.org>
In-Reply-To: <20080119165809.GB11553@colo.lackof.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,

Have you given Grant's suggestion any further consideration?

I'd like to know how the MMCONFIG issues discussed in this thread are going
to be handled upstream. I have a patch implemented in RHEL 5.2, but I would
rather have the upstream patch implemented, whatever it is.


Grant Grundler wrote:
> On Tue, Jan 15, 2008 at 10:56:41AM -0700, Matthew Wilcox wrote:
>> On Tue, Jan 15, 2008 at 09:46:43AM -0800, Greg KH wrote:
>>> But so far, we have a zillion patches floating around, claiming
>>> different things, some with signed-off-bys and others without, so for
>>> now, I'll just stick with Arjan's patch in -mm and see if anyone
>>> complains about those releases...
>> I complain about Arjan's patch.  For reasons which have been adequately
>> gone into already in this thread.
> 
> Agreed.
> Greg, I think at least two better alternatives were proposed already.
> Please review the thread again.
> 
> grant

