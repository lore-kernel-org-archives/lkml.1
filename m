Return-Path: <linux-kernel-owner+w=401wt.eu-S1756873AbYKDQbA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756873AbYKDQbA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 11:31:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755405AbYKDQau
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 11:30:50 -0500
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:49308 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755257AbYKDQat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 11:30:49 -0500
Date: Tue, 4 Nov 2008 17:30:38 +0100
From: Rodolfo Giometti <giometti@enneenne.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, gregkh@suse.de
Message-ID: <20081104163038.GF32133@tekkaman>
References: <20081103183214.aac32543.sfr@canb.auug.org.au> <20081103155047.GA14489@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081103155047.GA14489@x200.localdomain>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: 192.168.32.254
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: next-20081103: oxu210hp-hcd.c:3849: error: implicit
	declaration of function 'set_irq_type'
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 03, 2008 at 06:50:47PM +0300, Alexey Dobriyan wrote:
> On sparc:
> 
> drivers/usb/host/oxu210hp-hcd.c:3849: error: implicit declaration of function 'set_irq_type'
> 
> and including linux/irq.h doesn't cut it CONFIG_GENERIC_HARDIRQS aren't set.

Should I force CONFIG_GENERIC_HARDIRQS selection?

Ciao,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming                     skype:  rodolfo.giometti
