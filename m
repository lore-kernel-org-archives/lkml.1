Return-Path: <linux-kernel-owner+w=401wt.eu-S1756259AbYAOTlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756259AbYAOTlX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 14:41:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751097AbYAOTlH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 14:41:07 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49346 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755450AbYAOTlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 14:41:04 -0500
Date: Tue, 15 Jan 2008 11:38:42 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Tony Camuso <tcamuso@redhat.com>
cc: Matthew Wilcox <matthew@wil.cx>, Greg KH <greg@kroah.com>,
       Loic Prylli <loic@myri.com>, Adrian Bunk <bunk@kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
       linux-pci@atrey.karlin.mff.cuni.cz, Martin Mares <mj@ucw.cz>
Subject: Re: [Patch v2] Make PCI extended config space (MMCONFIG) a driver
 opt-in
In-Reply-To: <478D0928.9020802@redhat.com>
Message-ID: <alpine.LFD.1.00.0801151137390.2806@woody.linux-foundation.org>
References: <20080111235856.GA16079@jurassic.park.msu.ru> <20080112002638.GA18710@kroah.com> <20080112144030.GA19279@jurassic.park.msu.ru> <1200208085.6896.134.camel@pasglop> <20080113072415.GB18741@parisc-linux.org> <20080113090108.3224698c@laptopd505.fenrus.org>
 <20080114225225.GQ18741@parisc-linux.org> <20080114230448.GL9847@does.not.exist> <478CD8A5.5090608@myri.com> <20080115174643.GB28238@kroah.com> <20080115175641.GE18741@parisc-linux.org> <478D0928.9020802@redhat.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 15 Jan 2008, Tony Camuso wrote:
> 
> Linus is confident that conf1 is not going away for at least the
> next five years.

Not on PC's. Small birds tell me that there can be all these non-PC x86 
subarchitectures that may or may not have conf1.

		Linus
