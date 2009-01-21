Return-Path: <linux-kernel-owner+w=401wt.eu-S1755189AbZAUXkg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755189AbZAUXkg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 18:40:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752934AbZAUXk1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 18:40:27 -0500
Received: from h4320.serverkompetenz.net ([81.169.172.102]:57081 "EHLO
	www.deb-support.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752817AbZAUXk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 18:40:26 -0500
Date: Wed, 21 Jan 2009 23:40:23 +0000
From: Michael Bramer <michael@debsupport.de>
To: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] drivers/serial/8250_pci.c (add support for '8-port RS-232 MIC-3620 from advantech'
Message-ID: <20090121234023.GA10645@deb-support.de>
References: <20090118135359.GA3087@deb-support.de> <20090119145101.GA16732@ports.donpac.ru> <20090119235122.GE21026@deb-support.de> <20090120151216.GB16732@ports.donpac.ru> <20090121075212.GA18485@deb-support.de> <4976DA3D.7050201@teltonika.lt>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4976DA3D.7050201@teltonika.lt>
User-Agent: Mutt/1.5.9i
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: grisu@deb-support.de
X-SA-Exim-Scanned: No (on www.deb-support.de); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2009 at 10:18:05AM +0200, Paulius Zaleckas wrote:
> Michael Bramer wrote:
> > the new patch:
> > --------------
> > This Patch add the device information for the 
> > MIC-3620 8-port RS-232 cPCI card from Advantech Co. Ltd.
> > 
> > Signed-off-by: Michael Bramer <grisu@deb-support.de>
> > --- a/drivers/serial/8250_pci.c
> > +++ b/drivers/serial/8250_pci.c
> > @@ -31,6 +31,7 @@
> >  #include "8250.h"
> > 
> >  #undef SERIAL_DEBUG_PCI
> > +#define SERIAL_DEBUG_PCI
> 
> NAK.

sorry, this was a bug in the patch.

Gruss
Grisu
-- 
Michael Bramer  -- http://www.feuerwehr.kreuzau.de/wiki/
PGP: finger grisu@db.debian.org  -- Linux Sysadmin   -- Use Debian Linux
"Wenn ich die Folgen geahnt hätte, wäre ich Uhrmacher geworden!"
                                                 --- Albert Einstein
