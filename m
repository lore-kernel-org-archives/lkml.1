Return-Path: <linux-kernel-owner+w=401wt.eu-S1422900AbXBAOpJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422900AbXBAOpJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 09:45:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422906AbXBAOpI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 09:45:08 -0500
Received: from caffeine.uwaterloo.ca ([129.97.134.17]:47694 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422900AbXBAOpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 09:45:07 -0500
Date: Thu, 1 Feb 2007 09:45:06 -0500
To: Erik Mouw <erik@harddisk-recovery.com>
Cc: Jeff Garzik <jeff@garzik.org>, Roland Dreier <rdreier@cisco.com>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: Free Linux Driver Development!
Message-ID: <20070201144506.GD7582@csclub.uwaterloo.ca>
References: <ada8xfks90x.fsf@cisco.com> <20070130191020.GF20642@kroah.com> <adaodogqpmx.fsf@cisco.com> <45BFA087.6020905@garzik.org> <ada4pq8qjpd.fsf@cisco.com> <20070130214759.GA12477@kroah.com> <adar6tcp43r.fsf@cisco.com> <45BFC2CF.8010603@garzik.org> <20070130222344.GF7584@csclub.uwaterloo.ca> <20070201135903.GE29212@harddisk-recovery.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070201135903.GE29212@harddisk-recovery.com>
User-Agent: Mutt/1.5.9i
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 01, 2007 at 02:59:03PM +0100, Erik Mouw wrote:
> I can't remember that kind of corruption ever being reported to the
> bcm43xx-dev mailing list.

Well I assumed it messed up the eeprom settings, since we had to go into
the advanced driver settings and change it from 802.11b only back to
auto mode and I would think those settings are stored in the eeprom if
booting a 2.6.18 kernel and loading the bcm43xx driver can cause it to
stop working, then it has to be an eeprom setting.

Actually I suppose the other posibility is that you simply have to power
cycle before booting windows after linux to avoid any left over settings
in the chip from being a problem.  That may be what I did.  Given I
couldn't get the card to connect using the bcm43xx driver anyhow, I
didn't spend too much time trying (I am fairly sure I set the AP to
802.11g only though which may have been a problem).

> You could use a CardBus or USB card.

I just don't like things sticking out that are breakable.

> So are the bcm43xx maintainers.

Excellent.  Is the bcm43xx planning to get 802.11g mode working at some
point?  Is broadcom ever going to help out with any specs for their
hardware or do they still mistakenly believe that end users are not
their customers?  Given the behaviour of broadcom over the years I know
I don't intend to buy anything with a broadcom chip in it again, which
means broadcom's behaviour directly means they will get less sales to the
laptop makers, since some people will actively avoid anything with
broadcom's hardware in it. :)

--
Len Sorensen
