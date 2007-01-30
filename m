Return-Path: <linux-kernel-owner+w=401wt.eu-S1751816AbXA3WXq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751816AbXA3WXq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 17:23:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751794AbXA3WXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 17:23:45 -0500
Received: from caffeine.uwaterloo.ca ([129.97.134.17]:39125 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751816AbXA3WXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 17:23:44 -0500
Date: Tue, 30 Jan 2007 17:23:44 -0500
To: Jeff Garzik <jeff@garzik.org>
Cc: Roland Dreier <rdreier@cisco.com>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Free Linux Driver Development!
Message-ID: <20070130222344.GF7584@csclub.uwaterloo.ca>
References: <20070130012904.GA9617@kroah.com> <ada8xfks90x.fsf@cisco.com> <20070130191020.GF20642@kroah.com> <adaodogqpmx.fsf@cisco.com> <45BFA087.6020905@garzik.org> <ada4pq8qjpd.fsf@cisco.com> <20070130214759.GA12477@kroah.com> <adar6tcp43r.fsf@cisco.com> <45BFC2CF.8010603@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45BFC2CF.8010603@garzik.org>
User-Agent: Mutt/1.5.9i
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 30, 2007 at 05:12:31PM -0500, Jeff Garzik wrote:
> You mean the bcm43xx wireless driver that's been upstream for months?

And seems to do 802.11b only and screw up the eeprom settings so that
the windows driver gets confused next time you boot windows.  Lovely
driver.  If the bios on the laptop in question would let me change the
minipci card I would.  To something with a ralink on it.

Seems the ralink driver maintainers are doing a lot of the work on the
core wifi infastructure too.  Lots of work beyond just the driver then.

--
Len Sorensen
