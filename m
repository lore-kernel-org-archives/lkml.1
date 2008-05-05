Return-Path: <linux-kernel-owner+w=401wt.eu-S1759567AbYEEOJy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759567AbYEEOJy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 10:09:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755341AbYEEOJp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 10:09:45 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:37718 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754720AbYEEOJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 10:09:44 -0400
Date: Mon, 5 May 2008 16:10:34 +0200
From: Pavel Machek <pavel@suse.cz>
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Suspend to memory is freezing my machine
Message-ID: <20080505141034.GD5351@elf.ucw.cz>
References: <c4e36d110805040037u1b98c027x46dc17bf6be5da5b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c4e36d110805040037u1b98c027x46dc17bf6be5da5b@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Also - I think that option no_console_suspend doens't work correctly -
> as many times with suspend I do not see any log message on my console
> screen. However sometimes the log is shown.

Try switching consoles with alt-arrows... s2ram plays with console
switches so messages may be there but on other console.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
