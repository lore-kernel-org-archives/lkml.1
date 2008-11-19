Return-Path: <linux-kernel-owner+w=401wt.eu-S1753363AbYKSNP5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363AbYKSNP5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 08:15:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752909AbYKSNPs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 08:15:48 -0500
Received: from mathups.math.u-psud.fr ([129.175.52.4]:52039 "EHLO
	matups.math.u-psud.fr" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752914AbYKSNPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 08:15:47 -0500
X-Greylist: delayed 1554 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Nov 2008 08:15:47 EST
From: Duncan Sands <duncan.sands@math.u-psud.fr>
To: mikie <mikie.pl@gmail.com>
Subject: Re: understanding firmware loader for speedtouch (kernel 2.6.21.5)
Date: Wed, 19 Nov 2008 13:49:42 +0100
User-Agent: KMail/1.10.1 (Linux/2.6.27-7-generic; KDE/4.1.73; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <ca35ce500707060554v71ebdca3k8ef18e4c0a44c9cb@mail.gmail.com> <200707250103.54477.duncan.sands@math.u-psud.fr> <ca35ce500811190425i221a1fcapaaaf1cd9cae0a011@mail.gmail.com>
In-Reply-To: <ca35ce500811190425i221a1fcapaaaf1cd9cae0a011@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811191349.42445.duncan.sands@math.u-psud.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> Do you have any news regarding my case of slow transfers via
> >> Speedtouch USB modem on linux ?
> >
> > I found my old speedtouch modem and tested here.  I got 2.1 Mbaud
> > bulk downspeed, and 3 Mbaud isoc downspeed.  This last is half the
> > speed my line supports, so something is wrong [*].  Unfortunately
> > I'm not very motivated to try to find out what, because I don't
> > use this modem myself anymore.  It looks like someone needs to do
> > some more reverse engineering work on the windows driver.
> 
> Duncan, as you remember we discussed 1 year ago speed issues with
> Speedtouch driver. Please let me know if the driver has been fixed to
> support higher speeds? Or is it still limited to 3Mbaud top ?

Nothing changed, so I suppose it is still slow.  I'm not planning
to work on this - I no longer have any interest in these modems
(I should really remove myself as maintainer).

Sorry for the bad news,

Duncan.
