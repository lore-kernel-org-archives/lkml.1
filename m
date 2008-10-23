Return-Path: <linux-kernel-owner+w=401wt.eu-S1755056AbYJWWU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755056AbYJWWU3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 18:20:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751941AbYJWWUS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 18:20:18 -0400
Received: from heinz.dinsnail.net ([87.106.63.74]:38978 "EHLO
	heinz.dinsnail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772AbYJWWUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 18:20:17 -0400
Date: Thu, 23 Oct 2008 23:33:09 +0200
From: Michael Weiser <michael@weiser.dinsnail.net>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: rtc/i2c-mpc stops working with 2.6.27 on Linkstation HG
	(powerpc)
Message-ID: <20081023213309.GA19777@weiser.dinsnail.net>
References: <20081022191650.GA11406@weiser.dinsnail.net> <Pine.LNX.4.64.0810232029380.9657@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0810232029380.9657@axis700.grange>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-dinsnail.net-MailScanner-ID: m9NMK890010147
X-MailScanner: Found to be clean
X-MailScanner-From: michael@weiser.dinsnail.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2008 at 08:30:23PM +0200, Guennadi Liakhovetski wrote:

> > with 2.6.27(-gentoo) the rtc (Ricoh 5c372) is no longer found on my
> > Linkstation HG. It seems, the i2c-mpc driver doesn't even find the I2C
> > controller.

> This is a known regression, see, e.g., here:

> http://ozlabs.org/pipermail/linuxppc-dev/2008-October/064318.html

> waiting for someone to find time to fix it.

Cheers. I found the thread but not the pertinent posts - the web mail
archive I googled into must have been lagging. Sorry for the
duplication.
-- 
bye, Michael
