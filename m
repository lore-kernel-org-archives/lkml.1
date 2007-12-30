Return-Path: <linux-kernel-owner+w=401wt.eu-S1757258AbXL3NjF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757258AbXL3NjF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 08:39:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753040AbXL3Niy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 08:38:54 -0500
Received: from mk-filter-2-a-1.mail.uk.tiscali.com ([212.74.100.53]:8368 "EHLO
	mk-filter-2-a-4.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752813AbXL3Nix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 08:38:53 -0500
X-Trace: 653613198/mk-filter-2.mail.uk.tiscali.com/B2C/$THROTTLED-DYNAMIC/CUSTOMER-DYNAMIC-IP/81.1.89.80
X-SBRS: None
X-RemoteIP: 81.1.89.80
X-IP-MAIL-FROM: adrian@newgolddream.dyndns.info
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aj0KAMotd0dRAVlQ/2dsb2JhbACBV6cP
Subject: Re: [PATCH] SH/Dreamcast - add support for GD-Rom device
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: Joe Perches <joe@perches.com>
Cc: Paul Mundt <lethal@linux-sh.org>, Jens Axboe <jens.axboe@oracle.com>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-sh <linux-sh@vger.kernel.org>
In-Reply-To: <1198796281.4833.31.camel@localhost>
References: <1198774339.6170.11.camel@localhost.localdomain>
	 <1198796281.4833.31.camel@localhost>
Content-Type: text/plain
Date: Sun, 30 Dec 2007 13:38:24 +0000
Message-Id: <1199021904.6222.7.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2007-12-27 at 14:58 -0800, Joe Perches wrote:
> On Thu, 2007-12-27 at 16:52 +0000, Adrian McMenamin wrote:
> > This patch adds support for the CD-Rom drive on the SEGA Dreamcast.
> 
> Because it was already so close, might as well make it checkpatch clean.
> 
> I also added a function gdrom_is_busy() to make a couple of tests
> fit on a single line and perhaps easier to read.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 
Not really for me to decide if this gets applied - I'll leave that to
Paul as the maintainer. But I have no objection to them :)

