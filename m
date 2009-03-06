Return-Path: <linux-kernel-owner+w=401wt.eu-S1754728AbZCFDu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728AbZCFDu2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 22:50:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753416AbZCFDuR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 22:50:17 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:30025 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381AbZCFDuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 22:50:16 -0500
Date: Thu, 5 Mar 2009 19:51:18 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Alex Buell <alex.buell@munted.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Linux Frame Buffer Device Development 
	<linux-fbdev-devel@lists.sourceforge.net>
Subject: Re: [PATCH] Incorrect URL given in drivers/video/Kconfig
Message-Id: <20090305195118.110b18ae.randy.dunlap@oracle.com>
In-Reply-To: <Pine.LNX.4.64.0902192156560.2221@anakin>
References: <20090117233539.07abdfc2@lithium.local.net>
	<Pine.LNX.4.64.0902192156560.2221@anakin>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt704.oracle.com [141.146.40.82]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.49B09D55.0044:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Feb 2009 21:58:13 +0100 (CET) Geert Uytterhoeven wrote:

> On Sat, 17 Jan 2009, Alex Buell wrote:
> > --- linux/drivers/video/Kconfig.old	2009-01-17 23:31:53.831765544 +0000
> > +++ linux/drivers/video/Kconfig	2009-01-17 23:32:40.049414838 +0000
> > @@ -41,7 +41,7 @@
> >  	  You need an utility program called fbset to make full use of frame
> >  	  buffer devices. Please read <file:Documentation/fb/framebuffer.txt>
> >  	  and the Framebuffer-HOWTO at
> > -	  <http://www.tahallah.demon.co.uk/programming/prog.html> for more
> > +	  <http://www.munted.org.uk/programming/Framebuffer-HOWTO-1.2.html> for more
> 
> Which got obsoleted by
> http://www.munted.org.uk/programming/Framebuffer-HOWTO-1.3.html in the mean
> time...
> 
> Any chance we could have a permanent link here?

Alex -- ping??

> >  	  information.
> >  
> >  	  Say Y here and to the driver for your graphics board below if you


---
~Randy
