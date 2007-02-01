Return-Path: <linux-kernel-owner+w=401wt.eu-S1422885AbXBAN7J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422885AbXBAN7J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 08:59:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422893AbXBAN7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 08:59:09 -0500
Received: from dtp.xs4all.nl ([80.126.206.180]:52607 "HELO abra2.bitwizard.nl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1422885AbXBAN7H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 08:59:07 -0500
Date: Thu, 1 Feb 2007 14:59:03 +0100
From: Erik Mouw <erik@harddisk-recovery.com>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: Jeff Garzik <jeff@garzik.org>, Roland Dreier <rdreier@cisco.com>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: Free Linux Driver Development!
Message-ID: <20070201135903.GE29212@harddisk-recovery.com>
References: <20070130012904.GA9617@kroah.com> <ada8xfks90x.fsf@cisco.com> <20070130191020.GF20642@kroah.com> <adaodogqpmx.fsf@cisco.com> <45BFA087.6020905@garzik.org> <ada4pq8qjpd.fsf@cisco.com> <20070130214759.GA12477@kroah.com> <adar6tcp43r.fsf@cisco.com> <45BFC2CF.8010603@garzik.org> <20070130222344.GF7584@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070130222344.GF7584@csclub.uwaterloo.ca>
Organization: Harddisk-recovery.com
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 30, 2007 at 05:23:44PM -0500, Lennart Sorensen wrote:
> On Tue, Jan 30, 2007 at 05:12:31PM -0500, Jeff Garzik wrote:
> > You mean the bcm43xx wireless driver that's been upstream for months?
> 
> And seems to do 802.11b only and screw up the eeprom settings so that
> the windows driver gets confused next time you boot windows.  Lovely
> driver.

I can't remember that kind of corruption ever being reported to the
bcm43xx-dev mailing list.

>  If the bios on the laptop in question would let me change the
> minipci card I would.  To something with a ralink on it.

You could use a CardBus or USB card.

> Seems the ralink driver maintainers are doing a lot of the work on the
> core wifi infastructure too.  Lots of work beyond just the driver then.

So are the bcm43xx maintainers.


Erik

-- 
+-- Erik Mouw -- www.harddisk-recovery.com -- +31 70 370 12 90 --
| Lab address: Delftechpark 26, 2628 XH, Delft, The Netherlands
