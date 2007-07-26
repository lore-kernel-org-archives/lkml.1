Return-Path: <linux-kernel-owner+w=401wt.eu-S933355AbXGZIFw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933355AbXGZIFw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 04:05:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760212AbXGZIEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 04:04:53 -0400
Received: from smtp-out001.kontent.com ([81.88.40.215]:49563 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933159AbXGZIEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 04:04:51 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Tino Keitel <tino.keitel@gmx.de>
Subject: Re: 2.6.23-rc1: USB hard disk broken
Date: Thu, 26 Jul 2007 10:06:40 +0200
User-Agent: KMail/1.9.7
Cc: linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <20070725072343.GA3483@dose.home.local> <200707251024.37112.oliver@neukum.org> <20070725181312.GA5612@dose.home.local>
In-Reply-To: <20070725181312.GA5612@dose.home.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707261006.41368.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch 25 Juli 2007 schrieb Tino Keitel:
> On Wed, Jul 25, 2007 at 10:24:36 +0200, Oliver Neukum wrote:
> > Am Mittwoch 25 Juli 2007 schrieb Tino Keitel:
> > > Hi,
> > > 
> > > I just tried 2.6.23-rc1 and shortly after the boot my external USB hard
> > > disk went mad.
> 
> [...]
> 
> > Please recompile with CONFIG_USB_DEBUG set.
> > 
> > 	Regards
> > 		Oliver
> 
> I tried, but it didn't happen again.

Did you try with the old kernel again? This bug may be related to timing.

	Regards
		Oliver
