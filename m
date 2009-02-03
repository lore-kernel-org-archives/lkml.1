Return-Path: <linux-kernel-owner+w=401wt.eu-S1752789AbZBCFSi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752789AbZBCFSi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 00:18:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750905AbZBCFS3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 00:18:29 -0500
Received: from kroah.org ([198.145.64.141]:41039 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750845AbZBCFS3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 00:18:29 -0500
Date: Mon, 2 Feb 2009 21:12:44 -0800
From: Greg KH <greg@kroah.com>
To: David Vrabel <david.vrabel@csr.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] UWB and WUSB fixes
Message-ID: <20090203051244.GA1826@kroah.com>
References: <49873632.6040108@csr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49873632.6040108@csr.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 02, 2009 at 06:06:42PM +0000, David Vrabel wrote:
>  drivers/usb/host/whci/asl.c       |    9 +++++++--
>  drivers/usb/host/whci/hw.c        |   15 +++++++++++++++
>  drivers/usb/host/whci/pzl.c       |    9 +++++++--
>  drivers/usb/host/whci/whcd.h      |    1 +
>  drivers/usb/wusbcore/devconnect.c |    1 +
>  drivers/usb/wusbcore/rh.c         |    3 +++

For patches under drivers/usb/ could you please route them through me?
It makes things a bit easier to coordinate at times.  Not that there is
a problem at all with these patches, but in the future it would be
nicer.

thanks,

greg k-h
