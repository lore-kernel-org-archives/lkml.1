Return-Path: <linux-kernel-owner+w=401wt.eu-S1757913AbZEKMQ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757913AbZEKMQ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 08:16:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756606AbZEKMQW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 08:16:22 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:51500 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754985AbZEKMQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 08:16:21 -0400
Date: Sun, 10 May 2009 07:37:53 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Kenneth Crudup <kenny@panix.com>
Cc: linux-pm@lists.linux-foundation.org, tuxonice-devel@lists.tuxonice.net,
       linux-kernel@vger.kernel.org
Subject: Re: [TuxOnIce-devel] [RFC] TuxOnIce
Message-ID: <20090510053753.GE1363@ucw.cz>
References: <1241620755-22133-1-git-send-email-nigel@tuxonice.net> <20090507120948.GA1531@ucw.cz> <Pine.LNX.4.64.0905070925500.8967@hp9800.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0905070925500.8967@hp9800.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-05-07 09:28:41, Kenneth Crudup wrote:
> 
> On Thu, 7 May 2009, Pavel Machek wrote:
> 
> > Given that distros ship uswsusp already... is that really an advantage.
> 
> Uswsusp has no compression. A suspend-to-disk that can take up to 5
> minutes in uswsusp takes 20 seconds with TuxOnIce. Uswsusp has no built-
> in hooks that allow me to run commands and set options during the suspend
> and resume process.

uswsusp supports compression, see suspend.sf.net. Oh and yes you can
interrupt it (with del key iirc).
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
