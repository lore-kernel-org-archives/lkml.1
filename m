Return-Path: <linux-kernel-owner+w=401wt.eu-S1754243AbZDVLhG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754243AbZDVLhG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 07:37:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752135AbZDVLgv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 07:36:51 -0400
Received: from d112a1.x-mailer.de ([212.162.53.11]:58469 "EHLO
	d112a1.x-mailer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062AbZDVLgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 07:36:50 -0400
X-Greylist: delayed 4815 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Apr 2009 07:36:50 EDT
From: Karsten Keil <isdn@linux-pingi.de>
Reply-To: isdn@linux-pingi.de
To: David Miller <davem@davemloft.net>
Subject: Re: [PATCH RFC v2] Documentation/isdn/INTERFACE.CAPI
Date: Wed, 22 Apr 2009 12:16:22 +0200
User-Agent: KMail/1.11.1 (Linux/2.6.27.19-3.2-default; KDE/4.2.1; x86_64; ; )
Cc: tilman@imap.cc, isdn4linux@listserv.isdn4linux.de,
       i4ldeveloper@listserv.isdn4linux.de, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <49E4E9CA.8000802@imap.cc> <20090421091852.9C31C111815@xenon.ts.pxnet.com> <20090422.023142.222186658.davem@davemloft.net>
In-Reply-To: <20090422.023142.222186658.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904221216.22740.isdn@linux-pingi.de>
X-Info: valid message
X-Info: original Date
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mittwoch, 22. April 2009 11:31:42 David Miller wrote:
> From: Tilman Schmidt <tilman@imap.cc>
> Date: Tue, 21 Apr 2009 11:18:52 +0200 (CEST)
>
> > @@ -8,6 +8,8 @@ INTERFACE
> >  	- description of isdn4linux Link Level and Hardware Level interfaces.
> >  INTERFACE.fax
> >  	- description of the fax subinterface of isdn4linux.
> > +INTERFACE.CAPI
> > +	- description of kernel CAPI Link Level to Hardware Level interface.
> >  README
> >  	- general info on what you need and what to do for Linux ISDN.
> >  README.FAQ
>
> There is no INTERFACE.fax entry in this file in the current
> tree.

Seems the file was never updated from the old CVS version.

>
> I wanted to apply this, but aparently your patch is against
> something other than Linus's tree or net-2.6
I will send a new signed patch after review in few hours.

Thanks to Tilman for this work.

Karsten

