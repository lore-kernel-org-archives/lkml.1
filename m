Return-Path: <linux-kernel-owner+w=401wt.eu-S1758309AbXEXKF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758309AbXEXKF1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 06:05:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755767AbXEXKFU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 06:05:20 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2349 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755679AbXEXKFT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 06:05:19 -0400
Date: Thu, 24 May 2007 10:04:56 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Jeff Garzik <jeff@garzik.org>
Cc: Greg KH <greg@kroah.com>, Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [stable] Wanted: Allow adding new device IDs during the	-stable cycle
Message-ID: <20070524100455.GB7444@ucw.cz>
References: <46533314.10206@redhat.com> <20070522184733.GA9357@kroah.com> <46533EA8.7020602@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46533EA8.7020602@garzik.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >So, because of that, I don't really see a need to be 
> >adding new device
> >ids to the -stable tree.
> 
> Maybe you are just not seeing all the developers that 
> keep bringing this up??
> 
> Really, it is just silly to think that one-line PCI IDs 
> patches will cause any harm at all, and it should be 
> self-evident that there is clear potential to HELP Linux 
> users.  That's why we're all here, right?

Well, in 2.6.73.1 we add 'trivial' one line to add new pci id, and in
2.6.73.2 we have data corruption, because that driver needed some
quirk we did not know about...?

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
