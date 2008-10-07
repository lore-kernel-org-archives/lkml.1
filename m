Return-Path: <linux-kernel-owner+w=401wt.eu-S1754003AbYJGTVe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003AbYJGTVe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 15:21:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752439AbYJGTV0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 15:21:26 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:52389 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495AbYJGTV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 15:21:26 -0400
Date: Tue, 7 Oct 2008 21:21:12 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: Pavel Machek <pavel@suse.cz>
Cc: linux-kernel@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>
Message-ID: <20081007192112.GL13035@tekkaman>
References: <1223374230-18413-1-git-send-email-giometti@enneenne.com> <20081007135420.GB1592@ucw.cz> <20081007152032.GH13035@tekkaman> <20081007185846.GA6604@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081007185846.GA6604@elf.ucw.cz>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: 192.168.32.254
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH V3] led: Backlight trigger for led subsystem
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2008 at 08:58:46PM +0200, Pavel Machek wrote:
> 
> Ok, what is it good for? So I have backlight, charging led and hdd led
> on my zaurus. Now I can set charging led to indicate backlight... but
> why is it useful?

On my board, for example, I have a led for each "special" buttons and
others to indicate to the user some "special" conditions of machine
internals. All these leds should be switched off each time the LCD
blanks and they should get their old brightness status when the LCD
unblanks.

Ciao,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming                     skype:  rodolfo.giometti
