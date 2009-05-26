Return-Path: <linux-kernel-owner+w=401wt.eu-S1761898AbZE0ADV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761898AbZE0ADV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 20:03:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760415AbZEZX5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 19:57:39 -0400
Received: from mail.crca.org.au ([67.207.131.56]:47682 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759103AbZEZX5i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 19:57:38 -0400
X-Bogosity: Ham, spamicity=0.000000
Subject: Re: [linux-pm] [TuxOnIce-devel] [RFC] TuxOnIce
From: Nigel Cunningham <nigel@tuxonice.net>
Reply-To: nigel@tuxonice.net
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Oliver Neukum <oliver@neukum.org>, linux-pm@lists.linux-foundation.org,
       tuxonice-devel@lists.tuxonice.net, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.44L0.0905261754250.11998-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.0905261754250.11998-100000@iolanthe.rowland.org>
Content-Type: text/plain
Date: Wed, 27 May 2009 09:59:26 +1000
Message-Id: <1243382366.13930.105.camel@nigel-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Tue, 2009-05-26 at 17:56 -0400, Alan Stern wrote:
> On Wed, 27 May 2009, Nigel Cunningham wrote:
> 
> > USB devices ought to be able to do _something_ though - I have a Dvico
> > Dual Digital 4 card
> 
> What is that?

It's a dual digital TV tuner that includes an IR receiver. It plugs into
a PCI slot, but registers two USB devices and an input driver.

> > that is forcing me to shutdown X, mythtv-backend,
> > pulse audio and lirc at the moment so that I can rmmod it while
> > hibernating. That ought not be necessary. I'm sure there are good
> > technical reasons why it is necessary at the mooment, but it shouldn't
> > be that way - even if it just does the bare minimum required to avoid
> > requiring the closing of files and the unload.
> 
> Probably the driver's author just never got around to adding support
> for suspend/resume.  Which driver is it?  What happens if you don't 
> rmmod it?

The hard drive on that box died on me and I'm just about to install a
new one so I can only say from memory right now. I think I'd better wait
until I do the reinstall before I say too much. I do believe you're
right though - I took a brief look and think there was no suspend or
resume support.

I'll get back to you as soon as I have more info - thanks for taking an
interest!

Regards,

Nigel

