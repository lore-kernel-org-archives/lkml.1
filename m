Return-Path: <linux-kernel-owner+w=401wt.eu-S1755971AbYDNKsJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755971AbYDNKsJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 06:48:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751618AbYDNKr4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 06:47:56 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4122 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751494AbYDNKr4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 06:47:56 -0400
Date: Mon, 14 Apr 2008 12:47:47 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Takashi Iwai <tiwai@suse.de>
Cc: perex@perex.cz, kernel list <linux-kernel@vger.kernel.org>
Subject: Re: usb audio: Fix another Dallas quirk
Message-ID: <20080414104747.GB4756@ucw.cz>
References: <20080329223241.GA5348@elf.ucw.cz> <s5hbq4chh3k.wl%tiwai@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hbq4chh3k.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Dallas USB speakers are buggy in more than one way. One of configs
> > they offer does not work at all.
> > 
> > Signed-off-by: Pavel Machek <pavel@suse.cz>
> 
> Applied this to ALSA tree, too.  Thanks.

Thanks!

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
