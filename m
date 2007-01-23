Return-Path: <linux-kernel-owner+w=401wt.eu-S932923AbXAWJih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932923AbXAWJih (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 04:38:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932921AbXAWJih
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 04:38:37 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2680 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932926AbXAWJih (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 04:38:37 -0500
Date: Tue, 23 Jan 2007 09:38:23 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Alessandro Di Marco <dmr@gmx.it>, linux-kernel@vger.kernel.org,
       vojtech@suse.cz
Subject: Re: [ANNOUNCE] System Inactivity Monitor v1.0
Message-ID: <20070123093823.GD6033@ucw.cz>
References: <877ivkrv5s.fsf@gmx.it> <20070119101103.GA5730@ucw.cz> <Pine.LNX.4.61.0701212201220.29213@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0701212201220.29213@yvahk01.tjqt.qr>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >While functionality is extremely interesting.... does it really have
> >to be in kernel?
> 
> I think so. While the X server grabs off any keyboard and mouse activity
> on its own, there is no such thing for the [read "all"] console[s].

I believe input subsystem can already do that.
							Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
