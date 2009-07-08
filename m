Return-Path: <linux-kernel-owner+w=401wt.eu-S1758668AbZGHIo6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758668AbZGHIo6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 04:44:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756702AbZGHIov
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 04:44:51 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49665 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756065AbZGHIou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 04:44:50 -0400
Date: Wed, 8 Jul 2009 10:44:40 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Greg KH <greg@kroah.com>, malchev@google.com
Cc: kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       Brian Swetland <swetland@google.com>
Subject: Re: HTC Dream camera support for staging
Message-ID: <20090708084439.GC20020@elf.ucw.cz>
References: <20090629114339.GA25552@elf.ucw.cz> <20090702200824.GJ10957@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090702200824.GJ10957@kroah.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-07-02 13:08:24, Greg KH wrote:
> On Mon, Jun 29, 2009 at 01:43:40PM +0200, Pavel Machek wrote:
> > 
> > This patch adds driver for HTC Dream camera. I guess driver is
> > slightly higher quality than usual for staging/ , but it is fairly big
> > and I don't feel like doing all the cleanups myself. Also some parts
> > can probably be removed, as they did not end up in shipping hardware..
> > 
> > The driver is actually so big that I'll attach it gzipped, otherwise
> > it would not pass maillist limits.
> > 
> > Signed-off-by: Pavel Machek <pavel@ucw.cz>
> > Cc: Brian Swetland <swetland@google.com>
> 
> Can you resubmit it with the original author descriptions?  It's not
> fair to them to have it shown up as coming from you.

Yes, done... and thanks.

Brian... I'd like to submit qdsp5 and smd code, too. Who should be
listed as their authors?

Oh and... thanks for the serial debugging cable. After short fight
(using ttyMSM2, not ttyS0 took me a while to figure), it seems to work.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
