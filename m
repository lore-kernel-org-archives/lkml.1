Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932078Ab0BBWfE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 17:35:04 -0500
Received: from kroah.org ([198.145.64.141]:35941 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756614Ab0BBWe6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 17:34:58 -0500
Date: Tue, 2 Feb 2010 14:29:59 -0800
From: Greg KH <greg@kroah.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Evgeniy Polyakov <zbr@ioremap.net>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alexander Beregalov <a.beregalov@gmail.com>
Subject: Re: [Bug #14894] pohmelfs: NULL pointer dereference
Message-ID: <20100202222959.GA11697@kroah.com>
References: <oBElxfTZdhL.A.bx.-vhOLB@chimera>
 <srmJ8vMxKPH.A.iAC.TwhOLB@chimera>
 <20091229163512.GA4958@ioremap.net>
 <200912292237.54182.rjw@sisk.pl>
 <20091230091433.GU4489@kernel.dk>
 <20100202205743.GA26703@ioremap.net>
 <20100202211809.GB8755@kroah.com>
 <20100202220456.GB29421@ioremap.net>
 <20100202222048.GN5733@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100202222048.GN5733@kernel.dk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 02, 2010 at 11:20:48PM +0100, Jens Axboe wrote:
> On Wed, Feb 03 2010, Evgeniy Polyakov wrote:
> > On Tue, Feb 02, 2010 at 01:18:09PM -0800, Greg KH (greg@kroah.com) wrote:
> > > > Jens, thanks a lot for you patch, Greg please pull it up.
> > > > If you did not find it or can not extract from the reply, I will resend.
> > > 
> > > Please resend it with a signed-off-by line so that I can apply it.
> > 
> > Done, thank you.
> 
> Greg, you can add mine as well, I didn't provide one in the original
> posting since it was just a test patch.

Will do.
