Return-Path: <linux-kernel-owner+w=401wt.eu-S965370AbXFGTeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965370AbXFGTeT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 15:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934959AbXFGTeK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 15:34:10 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:56602 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932728AbXFGTeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 15:34:09 -0400
Date: Thu, 7 Jun 2007 21:34:13 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Jesper Juhl <jesper.juhl@gmail.com>, Andy Whitcroft <apw@shadowen.org>,
       Andrew Morton <akpm@osdl.org>, Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] update checkpatch.pl to version 0.03
Message-ID: <20070607193413.GR5500@stusta.de>
References: <0a25fd03117c678f17006c5fcefaaed0@pinky> <9a8748490706060205y1fc8e354p4af7426fd76dd816@mail.gmail.com> <Pine.LNX.4.64.0706071622280.8762@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.64.0706071622280.8762@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2007 at 04:28:20PM +0200, Jan Engelhardt wrote:
> 
> On Jun 6 2007 11:05, Jesper Juhl wrote:
> >
> > - Source files should be 7bit ASCII
> 
> Nah. Think of....
> 
> MODULE_AUTHOR("J. Ørsted <jorsted@foobar.com>");
>...

NO!

Code must be 7bit ASCII.
This includes everything that gets into the kernel image.

> 	Jan

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

