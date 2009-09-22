Return-Path: <linux-kernel-owner+w=401wt.eu-S1752230AbZIVUHh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752230AbZIVUHh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 16:07:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751694AbZIVUHe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 16:07:34 -0400
Received: from casper.infradead.org ([85.118.1.10]:43117 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669AbZIVUHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 16:07:34 -0400
Date: Tue, 22 Sep 2009 22:07:47 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: gabe@blackfam.net
Cc: gabebblack@gmail.com, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, jbarnes@virtuousgeek.org
Subject: Re: TI PCIe-PCI bridge quirks
Message-ID: <20090922220747.702c3b11@infradead.org>
In-Reply-To: <8a15eb2b0909221237s5d3e408do4e3bed8aaaa337a8@mail.gmail.com>
References: <8a15eb2b0909221201k70b9e9darc6fda53f87bfae29@mail.gmail.com>
	<20090922211101.076e9763@infradead.org>
	<8a15eb2b0909221237s5d3e408do4e3bed8aaaa337a8@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Sep 2009 14:37:16 -0500
Gabe Black <gabebblack@gmail.com> wrote:

> On Tue, Sep 22, 2009 at 2:11 PM, Arjan van de Ven
> <arjan@infradead.org> wrote:
> >
> > sounds like this is worth a PCI quirk in the kernel...
> >
> 
> Is there documentation on how one would go about writing a "PCI
> quirk"?
> 

I would look at the existing quirks in the drivers/pci/quirks.c file...
plenty of good (or bad, depending on how you look at it) examples...

--  
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
