Return-Path: <linux-kernel-owner+w=401wt.eu-S1757915AbXFCOyd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757915AbXFCOyd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 10:54:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751472AbXFCOyY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 10:54:24 -0400
Received: from 81-174-11-161.f5.ngi.it ([81.174.11.161]:35880 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167AbXFCOyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 10:54:23 -0400
Date: Sun, 3 Jun 2007 16:55:32 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: linux-kernel@vger.kernel.org
Message-ID: <20070603145529.GC3879@enneenne.com>
References: <20070530165705.GD29337@enneenne.com> <4662AE11.70107@drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4662AE11.70107@drzeus.cx>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: mmc0: unrecognised SCR structure version 1
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 03, 2007 at 02:03:29PM +0200, Pierre Ossman wrote:
> 
> To my knowledge, no such version exists. So either your card is broken or you
> have some transfer problem on your board. What's the name of this card and have
> you tried any others?

I suppose the same... but this is the only cards who gives me such
problems! What do you think it could be the problem? Maybe some PXA
MMC special settings?

The card is a 512MB MiniSD by Viking InterWorks.

Thanks,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127
