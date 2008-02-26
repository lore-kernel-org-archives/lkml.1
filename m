Return-Path: <linux-kernel-owner+w=401wt.eu-S1759689AbYBZJIp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759689AbYBZJIp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 04:08:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754871AbYBZJI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 04:08:29 -0500
Received: from shoshil.marvell.com ([199.203.130.250]:42337 "EHLO
	il.marvell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752890AbYBZJI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 04:08:28 -0500
X-Greylist: delayed 921 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Feb 2008 04:08:27 EST
Date: Tue, 26 Feb 2008 00:39:25 -1100 (SST)
From: saeed <saeed@marvell.com>
X-X-Sender: saeed@ubuntu-saeed.il.marvell.com
To: Jeff Garzik <jeff@garzik.org>
cc: Mark Lord <liml@rtr.ca>, linux-ide@vger.kernel.org, jon@ngndg.com,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Sata-MV, Intergated Sata Device Support
In-Reply-To: <47C35A85.3020307@garzik.org>
Message-ID: <alpine.DEB.0.99.0802260024400.22022@ubuntu-saeed.il.marvell.com>
References: <1176673884.5109.30.camel@Desktop> <47C35203.20402@garzik.org>
 <47C3585D.8070701@rtr.ca> <47C35A85.3020307@garzik.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
X-OriginalArrivalTime: 26 Feb 2008 08:52:53.0679 (UTC) FILETIME=[F964FBF0:01C87854]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 25 Feb 2008, Jeff Garzik wrote:

> > ...
> > 
> > Saeed:  isn't this what your SOC patches already implemented for us?
> > As near as I can tell, sata_mv now already has support for the 60x1C0.
> 
> Saeed's stuff didn't support PCI though, and Jon Li is definitely talking
> about PCI...
yes, my patch added support for the SoC sata like in the 5182, and this 
is what Jon Li was concerned about. he mentioneded the 60x1C0 pci device 
just to suggest to use it's code for the SoC sata as it is very similar.

saeed
