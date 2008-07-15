Return-Path: <linux-kernel-owner+w=401wt.eu-S1761412AbYGORcJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761412AbYGORcJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 13:32:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753921AbYGORbx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 13:31:53 -0400
Received: from relais.videotron.ca ([24.201.245.36]:24398 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbYGORbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 13:31:52 -0400
MIME-version: 1.0
Content-type: multipart/mixed; boundary="Boundary_(ID_WVaOmNPgt6jwEv21NrtLig)"
Date: Tue, 15 Jul 2008 13:31:51 -0400 (EDT)
From: Nicolas Pitre <nico@cam.org>
X-X-Sender: nico@xanadu.home
To: Dan Williams <dcbw@redhat.com>
Cc: Michael Buesch <mb@bu3sch.de>,
       =?ISO-8859-15?Q?Stefanik_G=E1bor?= <netrolller.3d@gmail.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: Linux Wireless Mini-Summit -- Ottawa -- July 22, 2008
In-reply-to: <1216142191.6039.113.camel@localhost.localdomain>
Message-id: <alpine.LFD.1.10.0807151323570.12484@xanadu.home>
References: <20080709190915.GA8238@tuxdriver.com>
 <69e28c910807100912h30fcb57fpb4fb48b95c640f77@mail.gmail.com>
 <200807101815.27204.mb@bu3sch.de>
 <1216142191.6039.113.camel@localhost.localdomain>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--Boundary_(ID_WVaOmNPgt6jwEv21NrtLig)
Content-type: TEXT/PLAIN; charset=utf-8
Content-transfer-encoding: 8BIT

On Tue, 15 Jul 2008, Dan Williams wrote:

> On Thu, 2008-07-10 at 18:15 +0200, Michael Buesch wrote:
> > On Thursday 10 July 2008 18:12:32 Stefanik Gábor wrote:
> > > Some other topics which might be of interest/good to include:
> > > - New chipsets needing drivers (SiS 16x, Marvell, etc.)
> > 
> > I have no idea what to discuss about non-existing drivers, really.
> > Something like: "Do we need that driver? Everyone votes YES and is happy"?
> 
> Maybe during the week we could organize some hackfests to work on the
> Marvell/SiS/etc mac80211 drivers?  Everyone bring their favorite
> non-working Marvell 88w83xx card and we make mrv8k our bitch or
> something like that.

FYI...

Lennert Buytenhek and I are writing a GPL driver for mv8300 class of 
Marvell WIFI chips right now, present and future versions. This is 
Marvell work as we work for Marvell.  I have access to firmware sources, 
etc. but obviously cannot share them.

We both will be in Ottawa next week.


Nicolas

--Boundary_(ID_WVaOmNPgt6jwEv21NrtLig)--
