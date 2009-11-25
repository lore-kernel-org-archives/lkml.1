Return-Path: <linux-kernel-owner+w=401wt.eu-S934053AbZKYCML@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934053AbZKYCML (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 21:12:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758206AbZKYCMK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 21:12:10 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55078 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758185AbZKYCMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 21:12:09 -0500
Date: Tue, 24 Nov 2009 18:11:39 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: dbrownell@users.sourceforge.net, spi-devel-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Michal Simek <michal.simek@petalogix.com>
Subject: Re: [RFC] two new linux-next trees (SPI and devicetree)
Message-Id: <20091124181139.b9e218ed.akpm@linux-foundation.org>
In-Reply-To: <fa686aa40911241753lca699c9sa9ca0a0585a9d39d@mail.gmail.com>
References: <fa686aa40911241654w6ceb2c96nb3a6a57ac1b471f5@mail.gmail.com>
	<20091124170419.92cb63f6.akpm@linux-foundation.org>
	<fa686aa40911241753lca699c9sa9ca0a0585a9d39d@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Nov 2009 18:53:21 -0700 Grant Likely <grant.likely@secretlab.ca> wrote:

> > My current stash:
> >
> >
> > atmel_spi-fix-dma-addr-calculation-for-len-buffer_size.patch
> > spi-controller-driver-for-designware-spi-core.patch
> > spi-add-pci-interface-driver-for-designware-spi-core.patch
> > spi-add-pci-interface-driver-for-designware-spi-core-fix.patch
> > spi-controller-driver-for-designware-spi-core-fix.patch
> > spidev-add-proper-section-markers.patch
> > spidev-use-declare_bitmap-instead-of-declaring-the-array.patch
> > spidev-use-declare_bitmap-instead-of-declaring-the-array-checkpatch-fixes.patch
> > spi-drain-mxc-spi-transfer-buffer-when-probing-device.patch
> > spi_s3c24xx-add-fiq-pseudo-dma-support.patch
> 
> Since they're already in your tree, do you mind continuing to shepherd
> these (either merge or drop)?

Sure.

> > I haven't heard anything from David in over a month.
> 
> Okay, shall I go ahead and merge my change to MAINTAINERS through my
> tree too then?

OK by me.
