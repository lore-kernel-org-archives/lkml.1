Return-Path: <linux-kernel-owner+w=401wt.eu-S1752932AbYCIJXd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752932AbYCIJXd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 05:23:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752041AbYCIJXY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 05:23:24 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4463 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750869AbYCIJXX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 05:23:23 -0400
Date: Sun, 9 Mar 2008 10:01:55 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Pozsar Balazs <pozsy@uhulinux.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: suspend not working on macbook pro
Message-ID: <20080309090155.GB3866@ucw.cz>
References: <20080308110626.GE4491@ojjektum.uhulinux.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080308110626.GE4491@ojjektum.uhulinux.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> I'm using a macbook pro 3,1 (mid-2007), and suspend worked ok with 
> kernel 2.6.23.x, but with 2.6.25-rc{1,2,3,4} it just freezes during 
> suspend. The console is still on, the disk is powered off, but no 
> response or poweroff...
> 
> Did anyone else met the same thing? How could I help debug it?
> What other info would you need?

Find more exact version when it broke? git bisect?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
