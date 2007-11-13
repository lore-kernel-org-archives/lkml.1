Return-Path: <linux-kernel-owner+w=401wt.eu-S1762847AbXKMWkr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762847AbXKMWkr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 17:40:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759624AbXKMWkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 17:40:37 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:51414 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759409AbXKMWkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 17:40:36 -0500
Date: Tue, 13 Nov 2007 22:34:37 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>, Mark Lord <liml@rtr.ca>,
       alsa-devel@alsa-project.org, netdev@vger.kernel.org,
       linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org,
       Natalie Protasevich <protasnb@gmail.com>, linux-ide@vger.kernel.org,
       bugme-daemon@bugzilla.kernel.org, linux-input@atrey.karlin.mff.cuni.cz,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [BUG] New Kernel Bugs
Message-ID: <20071113223437.GG1356@flint.arm.linux.org.uk>
Mail-Followup-To: Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Thomas Gleixner <tglx@linutronix.de>, Mark Lord <liml@rtr.ca>,
	alsa-devel@alsa-project.org, netdev@vger.kernel.org,
	linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org,
	Natalie Protasevich <protasnb@gmail.com>, linux-ide@vger.kernel.org,
	bugme-daemon@bugzilla.kernel.org,
	linux-input@atrey.karlin.mff.cuni.cz,
	Andrew Morton <akpm@linux-foundation.org>
References: <32209efe0711122242m3a5f081asf1c11a38b24db10c@mail.gmail.com> <20071113031553.3c7b5c16.akpm@linux-foundation.org> <4739ADA2.4060604@rtr.ca> <alpine.LFD.0.9999.0711131521590.3265@localhost.localdomain> <20071113181053.GB1356@flint.arm.linux.org.uk> <20071113182516.250de873@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071113182516.250de873@the-village.bc.nu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2007 at 06:25:16PM +0000, Alan Cox wrote:
> > Given the wide range of ARM platforms today, it is utterly idiotic to
> > expect a single person to be able to provide responses for all ARM bugs.
> > I for one wish I'd never *VOLUNTEERED* to be a part of the kernel
> > bugzilla, and really *WISH* I could pull out of that function.
> 
> You can. Perhaps that bugzilla needs to point to some kind of
> arm-maintainers@vger.kernel.org list for the various ARM platform
> maintainers ?

That might work - though it would be hard to get all the platform
maintainers to be signed up to yet another mailing list, I'm sure
sufficient would do.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
