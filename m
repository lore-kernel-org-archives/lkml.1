Return-Path: <linux-kernel-owner+w=401wt.eu-S1754402AbZDVLnv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754402AbZDVLnv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 07:43:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752031AbZDVLnk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 07:43:40 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:37344 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535AbZDVLnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 07:43:39 -0400
Date: Wed, 22 Apr 2009 13:45:45 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Karsten Keil <isdn@linux-pingi.de>, Randy Dunlap <rdunlap@xenotime.net>
Cc: David Miller <davem@davemloft.net>, tilman@imap.cc,
       isdn4linux@listserv.isdn4linux.de, i4ldeveloper@listserv.isdn4linux.de,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC v2] Documentation/isdn/INTERFACE.CAPI
Message-ID: <20090422114545.GA31312@uranus.ravnborg.org>
References: <49E4E9CA.8000802@imap.cc> <20090421091852.9C31C111815@xenon.ts.pxnet.com> <20090422.023142.222186658.davem@davemloft.net> <200904221216.22740.isdn@linux-pingi.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904221216.22740.isdn@linux-pingi.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 22, 2009 at 12:16:22PM +0200, Karsten Keil wrote:
> On Mittwoch, 22. April 2009 11:31:42 David Miller wrote:
> > From: Tilman Schmidt <tilman@imap.cc>
> > Date: Tue, 21 Apr 2009 11:18:52 +0200 (CEST)
> >
> > > @@ -8,6 +8,8 @@ INTERFACE
> > >  	- description of isdn4linux Link Level and Hardware Level interfaces.
> > >  INTERFACE.fax
> > >  	- description of the fax subinterface of isdn4linux.
> > > +INTERFACE.CAPI
> > > +	- description of kernel CAPI Link Level to Hardware Level interface.
> > >  README
> > >  	- general info on what you need and what to do for Linux ISDN.
> > >  README.FAQ
> >
> > There is no INTERFACE.fax entry in this file in the current
> > tree.
> 
> Seems the file was never updated from the old CVS version.
> 
> >
> > I wanted to apply this, but aparently your patch is against
> > something other than Linus's tree or net-2.6
> I will send a new signed patch after review in few hours.
> 
> Thanks to Tilman for this work.

Try copying Randy on the patch - he is good at reviewing documentation.

	Sam
