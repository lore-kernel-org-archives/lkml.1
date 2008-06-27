Return-Path: <linux-kernel-owner+w=401wt.eu-S1758486AbYF0IIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758486AbYF0IIW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 04:08:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754623AbYF0IH2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 04:07:28 -0400
Received: from web32608.mail.mud.yahoo.com ([68.142.207.235]:24012 "HELO
	web32608.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753610AbYF0IHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 04:07:03 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Jun 2008 04:07:03 EDT
X-Mailer: YahooMailRC/975.45 YahooMailWebService/0.7.199
Date: Fri, 27 Jun 2008 01:00:21 -0700 (PDT)
From: Martin Knoblauch <knobi@knobisoft.de>
Subject: Re: AdvFS released under GPLv2
To: Pavel Machek <pavel@suse.cz>, Willy Tarreau <w@1wt.eu>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <434464.5667.qm@web32608.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message ----

> From: Pavel Machek <pavel@suse.cz>
> To: Willy Tarreau <w@1wt.eu>
> Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>; linux-kernel@vger.kernel.org; linux-fsdevel@vger.kernel.org
> Sent: Thursday, June 26, 2008 5:11:15 PM
> Subject: Re: AdvFS released under GPLv2
> 
> Hi!
> 
> > > HP has released AdvFS, a file system that was developed by Digital
> > > Equipment Corp
> > > and continues to be part of HP's Tru64 operating system.
> > 
> > Wow! That's awesome. I discovered it in 1999 and 9 years later, it probably
> > remains the most advanced FS I encountered. That was a major reason I was
> > sad to see Digital Unix die.
> 
> That's something I missed in the press release... what is so advanced
> about AdvFS? What is the killer feature?
> 

 You have to see this in context. Incidentially, I also got in contact with True64 and AdvFS at about the same time after long IRIX experience. At that time AdvFS definitely was advanced to anything available on True64. Comparable to the situation with other proprietary OSes - journaled high-availability filesystems just were not the standard. Neither was a fully integrated volume manager...

 Wheter AdvFS is still really "advanced" I cannot say, but good that the internals are now open. If only to learn from.

 Btw. XFS on IRIX was the really advanced FS at that time, of course :-)

Cheers
Martin

