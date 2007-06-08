Return-Path: <linux-kernel-owner+w=401wt.eu-S968888AbXFHN7n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968888AbXFHN7n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 09:59:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967867AbXFHN7d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 09:59:33 -0400
Received: from havoc.gtf.org ([69.61.125.42]:57155 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966995AbXFHN7d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 09:59:33 -0400
Date: Fri, 8 Jun 2007 09:59:31 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Jiri Slaby <jirislaby@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Korb <ml@akana.de>, linux-ide@vger.kernel.org
Subject: Re: [PATCH 1/1] ide: ide-generic, add another device exception
Message-ID: <20070608135931.GB24346@havoc.gtf.org>
References: <20601315171560711667@wsc.cz> <200706081418.56217.bzolnier@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706081418.56217.bzolnier@gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2007 at 02:18:55PM +0200, Bartlomiej Zolnierkiewicz wrote:
> On Monday 04 June 2007, Jiri Slaby wrote:
> > ide-generic, add another device exception
> 
> ide-generic is a generic ISA IDE driver, this one is drivers/ide/pci/generic
> (a generic IDE PCI driver) - fixed patch description to avoid confusion.
> 
> [ Yes, both drivers need a rename - patches are welcomed. ]

Probably best to do a rename from your side, in git.

	Jeff



