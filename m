Return-Path: <linux-kernel-owner+w=401wt.eu-S1755760AbXJXJ41@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755760AbXJXJ41 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 05:56:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753408AbXJXJ4T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 05:56:19 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:47855 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195AbXJXJ4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 05:56:19 -0400
Date: Wed, 24 Oct 2007 11:56:26 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Jiri Kosina <jikos@jikos.cz>
Cc: Marcel Holtmann <marcel@holtmann.org>,
       Alon Bar-Lev <alon.barlev@gmail.com>, linux-kernel@vger.kernel.org,
       bluez-devel@lists.sourceforge.net
Subject: Re: [BUG] rfcomm]
Message-ID: <20071024095626.GA18877@elf.ucw.cz>
References: <200710231950.31313.alon.barlev@gmail.com> <1193162106.6184.208.camel@violet> <Pine.LNX.4.64.0710232004260.18815@twin.jikos.cz> <1193163905.6184.214.camel@violet> <Pine.LNX.4.64.0710232026180.18815@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0710232026180.18815@twin.jikos.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2007-10-23 20:28:04, Jiri Kosina wrote:
> On Tue, 23 Oct 2007, Marcel Holtmann wrote:
> 
> > > actually uswsusp has been upstream for quite some time already. See 
> > > Documentation/power/userland-swsusp.txt
> > nice. I've never used it. Currently I am using what comes with Ubuntu
> > 7.10 and that seems to work.
> 
> Never used ubuntu, so I have no idea what they ship, I guess you use 
> s2ram/s2disk utilitie. If so, you are using uswsusp too.

Ubuntu may be crazy enough to use suspend2. Anyway, this is driver
problem, and I believe it is reproducible even with plain-old
in-kernel swsusp.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
