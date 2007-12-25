Return-Path: <linux-kernel-owner+w=401wt.eu-S1751491AbXLYVSs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751491AbXLYVSs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2007 16:18:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751130AbXLYVSj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Dec 2007 16:18:39 -0500
Received: from gate.crashing.org ([63.228.1.57]:47424 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751098AbXLYVSi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2007 16:18:38 -0500
Subject: Re: [RFC/PATCH 3/4] pci: Remove pci_enable_device_bars()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Grant Grundler <grundler@parisc-linux.org>
Cc: linux-pci@atrey.karlin.mff.cuni.cz, Alan Cox <alan@redhat.com>,
       Greg Kroah-Hartman <greg@kroah.com>, jgarzik@pobox.com,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, wingel@nano-system.com,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, james.smart@emulex.com,
       linux-driver@qlogic.com, linux-kernel@vger.kernel.org
In-Reply-To: <20071224070850.GB3758@colo.lackof.org>
References: <1197932473.576079.142524077033.qpush@grosgo>
	 <20071217230126.B2D71DDE36@ozlabs.org>
	 <20071224070850.GB3758@colo.lackof.org>
Content-Type: text/plain
Date: Wed, 26 Dec 2007 08:16:43 +1100
Message-Id: <1198617403.7209.0.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2007-12-24 at 00:08 -0700, Grant Grundler wrote:
> On Tue, Dec 18, 2007 at 10:01:14AM +1100, Benjamin Herrenschmidt wrote:
> > Now that all in-tree users are gone, this removes pci_enable_device_bars()
> > completely.
> 
> Almost completely.
> Patch below removes pci_enable_device_bars() from Documentation/pci.txt .
> 
> (And I'd be happy to review patches to pci.txt that add
>   pci_enable_device_io() and _mmio() as well. )
> 
> Signed-off-by: Grant Grundler <grundler@parisc-linux.org>

Will do.

Thanks !

Ben.


