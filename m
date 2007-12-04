Return-Path: <linux-kernel-owner+w=401wt.eu-S1752702AbXLDHSf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702AbXLDHSf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 02:18:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751705AbXLDHS2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 02:18:28 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4819 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751464AbXLDHS1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 02:18:27 -0500
Date: Tue, 4 Dec 2007 07:18:16 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Raymano Garibaldi <raymano@faunos.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [REQUEST] New boot flag/kernel option
Message-ID: <20071204071816.GA6248@ucw.cz>
References: <1618816c0711171002j7791e0b7g694498ef7448b2e0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1618816c0711171002j7791e0b7g694498ef7448b2e0@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2007-11-17 11:02:20, Raymano Garibaldi wrote:
> I would like to request a new boot flag/kernel option that would make
> the following scenario possible:
> 
> 1) Working on laptop with a live USB distro on a read-only USB stick.
> 2) Suspend laptop.
> 3) Detach USB stick.
> 
> 4) Do other things, get on a plane, go on a bus, deal with police
> officer giving you a ticket for operating a laptop while driving...
> 
> 5) Attach the same read-only USB stick.
> 6) Resume laptop.
> 7) Continue work as if nothing happened.
> 
> The last time we were able to do something like this was in 2.6.21.
> 
> If not, could you please advise a workaround to get this functionality
> with the latest kernels.

There's CONFIG switch in usb, exactly for this.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
