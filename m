Return-Path: <linux-kernel-owner+w=401wt.eu-S1759657AbXHaKq7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759657AbXHaKq7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 06:46:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932320AbXHaKqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 06:46:49 -0400
Received: from smtp-out001.kontent.com ([81.88.40.215]:56663 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757836AbXHaKqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 06:46:33 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: possible build system oddity
Date: Fri, 31 Aug 2007 12:46:34 +0200
User-Agent: KMail/1.9.6 (enterprise 20070731.694771)
Cc: Sam Ravnborg <sam@ravnborg.org>, Alexey Dobriyan <adobriyan@gmail.com>,
       linux-kernel@vger.kernel.org
References: <200708311037.29280.oliver@neukum.org> <200708311151.32618.oliver@neukum.org> <Pine.LNX.4.64.0708311237490.9413@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0708311237490.9413@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708311246.35460.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag 31 August 2007 schrieb Jan Engelhardt:
> On Aug 31 2007 11:51, Oliver Neukum wrote:
> >Am Freitag 31 August 2007 schrieb Sam Ravnborg:
> >> On Fri, Aug 31, 2007 at 01:14:26PM +0400, Alexey Dobriyan wrote:
> >> > On 8/31/07, Oliver Neukum <oliver@neukum.org> wrote:
> >> > > I only touched sound/usb/usbaudio.c
> >> > > Nevertheless the whole subtree und sound/ is recompiling. What's
> >> > > happening?
> >> > 
> >> > Not here. Do make V=2, it should say why it's recompiling.
> >> 
> >> And if the problem persist then do a make V=1 and post output here.
> >> This information combined should tell what goes wrong.
> >
> >Not reproducible. Sorry.
> 
> NFS/etc. involved?

No, exclusively on reiserfs.

	Regards
		Oliver

