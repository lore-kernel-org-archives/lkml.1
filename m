Return-Path: <linux-kernel-owner+w=401wt.eu-S933986AbZJIQ3m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933986AbZJIQ3m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 12:29:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933694AbZJIQ3l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 12:29:41 -0400
Received: from kroah.org ([198.145.64.141]:33648 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933862AbZJIQ3Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 12:29:25 -0400
Date: Fri, 9 Oct 2009 09:24:19 -0700
From: Greg KH <greg@kroah.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] Staging: updates for Ralink drivers
Message-ID: <20091009162419.GD2766@kroah.com>
References: <20090922184321.7695.11150.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090922184321.7695.11150.sendpatchset@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 22, 2009 at 08:43:21PM +0200, Bartlomiej Zolnierkiewicz wrote:
> 
> Hi,
> 
> Here are some major updates to Ralink drivers from the staging tree.
> 
> rt28x0 drivers are updated to match V2.1.0.0 vendor's drivers, rt2860
> driver gets RT3090 PCIe chipset support and no longer needed separate
> rt3090 driver is removed.
> 
> The end result is 100 KLOC gone and shared common code for all chipsets.
> 
> The patchset was tested with RT2860 and RT3070 chipsets.

Very cool work, thanks so much.  They are all now in my tree and in
linux-next.

greg k-h
