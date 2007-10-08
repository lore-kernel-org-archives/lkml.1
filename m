Return-Path: <linux-kernel-owner+w=401wt.eu-S1754210AbXJHH05@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210AbXJHH05 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 03:26:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750844AbXJHH0u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 03:26:50 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:60087 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797AbXJHH0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 03:26:49 -0400
Date: Mon, 8 Oct 2007 09:25:55 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Arjan van de Ven <arjan@infradead.org>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: irqbalance considered obsolete by powertop
Message-ID: <20071008072555.GA6316@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Powertop tells me that irqbalance is obsolete/burns too much power,
while it is default Y and its help test does not provide any clues:

Enable kernel irq balancing (IRQBALANCE) [Y/n/?] (NEW) ?

The default yes will allow the kernel to do irq load balancing.
Saying no will keep the kernel from doing irq load balancing.

...should the help text be updated?
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
