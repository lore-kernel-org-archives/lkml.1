Return-Path: <linux-kernel-owner+w=401wt.eu-S937409AbXFHFLd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937409AbXFHFLd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 01:11:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756521AbXFHFLZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 01:11:25 -0400
Received: from panic.printk.net ([217.147.83.20]:52653 "EHLO panic.printk.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755003AbXFHFLZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 01:11:25 -0400
X-Greylist: delayed 1745 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 Jun 2007 01:11:25 EDT
Subject: Re: [PATCH] update checkpatch.pl to version 0.03
From: Jon Masters <jonathan@jonmasters.org>
To: Adrian Bunk <bunk@stusta.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, jcm@jonmasters.org,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Jesper Juhl <jesper.juhl@gmail.com>, Andy Whitcroft <apw@shadowen.org>,
       Andrew Morton <akpm@osdl.org>, Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20070608000455.GW5500@stusta.de>
References: <0a25fd03117c678f17006c5fcefaaed0@pinky>
	 <9a8748490706060205y1fc8e354p4af7426fd76dd816@mail.gmail.com>
	 <Pine.LNX.4.64.0706071622280.8762@fbirervta.pbzchgretzou.qr>
	 <20070607193413.GR5500@stusta.de>
	 <20070607232248.332edee8@the-village.bc.nu>
	 <20070607232152.GU5500@stusta.de>
	 <20070608004117.57868755@the-village.bc.nu>
	 <20070608000455.GW5500@stusta.de>
Content-Type: text/plain
Organization: World Organi[sz]ation Of Broken Dreams
Date: Fri, 08 Jun 2007 00:37:38 -0400
Message-Id: <1181277458.4725.0.camel@jcmlaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-33.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-08 at 02:04 +0200, Adrian Bunk wrote:

> The difference is that "ls" expects and handles such issues while 
> "lsmod" (and most likely also other userspace working with kernel 
> output) does not yet handle it resulting in problems if bytes are 
> wrongly interpreted as control codes.

I'm happy to modify module-init-tools for Unicode support, I just didn't
think this was a huge issue - but now there's a test case so... :-)

Jon.


