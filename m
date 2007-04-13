Return-Path: <linux-kernel-owner+w=401wt.eu-S1753368AbXDMKxt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368AbXDMKxt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 06:53:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753418AbXDMKxt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 06:53:49 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:52524 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753368AbXDMKxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 06:53:48 -0400
Date: Fri, 13 Apr 2007 11:56:26 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Kyle McMartin <kyle@mcmartin.ca>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, kyle@canonical.com
Subject: Re: HPA patches
Message-ID: <20070413115626.097aadac@the-village.bc.nu>
In-Reply-To: <20070413031615.GA21061@athena.road.mcmartin.ca>
References: <20070323191321.5d00887a@lxorguk.ukuu.org.uk>
	<20070323112411.f6a8a762.randy.dunlap@oracle.com>
	<20070323200819.4e734f4f@lxorguk.ukuu.org.uk>
	<20070323130315.7ed48121.randy.dunlap@oracle.com>
	<20070413031615.GA21061@athena.road.mcmartin.ca>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Pondering about this, it's ATA_LBA according to the docs, specifying
> that the address is an LBA.

This is true for some commands, but not all. It gets used for other stuff
too.
