Return-Path: <linux-kernel-owner+w=401wt.eu-S1754382AbXFDLYn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382AbXFDLYn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 07:24:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752704AbXFDLYg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 07:24:36 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:48095 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752327AbXFDLYg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 07:24:36 -0400
Date: Mon, 4 Jun 2007 13:24:26 +0200
From: Pavel Machek <pavel@ucw.cz>
To: jikos@jikos.cz, kernel list <linux-kernel@vger.kernel.org>,
       dtor@insightbb.com
Subject: 2.6.22-rc[23]: blinking capslock led, stuck keys?
Message-ID: <20070604112426.GA2707@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I started getting blinking capslock leds in 2.6.22-somewhere. Every 5
seconds or so, capslock led toggles on thinkpad x60. Ouch.

I also get some stuck keys I was not getting before. I hope my
userland did not go crazy...
									Pavel 
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
