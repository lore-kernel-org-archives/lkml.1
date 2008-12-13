Return-Path: <linux-kernel-owner+w=401wt.eu-S1754732AbYLNJfo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732AbYLNJfo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 04:35:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752209AbYLNJfH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 04:35:07 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:36327 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827AbYLNJfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 04:35:04 -0500
Date: Sat, 13 Dec 2008 19:59:26 +0100
From: Pavel Machek <pavel@suse.cz>
To: jan sonnek <ha2nny@gmail.com>
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Warning -mmc card when Suspend
Message-ID: <20081213185926.GA1834@ucw.cz>
References: <494182DC.7080808@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <494182DC.7080808@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> When I suspend and then wake up my notebook I get this warning.
>
> [15409.820484] Broken read from PCI device 0000:05:01.4
> [15409.820493] ------------[ cut here ]------------
> [15409.820497] WARNING: at drivers/pci/pci.c:747 pci_save_state+0x50/0x189()
> [15409.820502] Hardware name: F3F
...
> When I insert my SD card the same problem I get and Registre dump, more  
> in my dmesg in attachement.

There was no  attachment. Are you trying to say that it happens w/o
the suspend, too?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
