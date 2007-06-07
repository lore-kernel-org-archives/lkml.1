Return-Path: <linux-kernel-owner+w=401wt.eu-S935992AbXFGTcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935992AbXFGTcc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 15:32:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933250AbXFGTcZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 15:32:25 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:56591 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759724AbXFGTcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 15:32:24 -0400
Date: Thu, 7 Jun 2007 21:32:29 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Andy Whitcroft <apw@shadowen.org>, Andrew Morton <akpm@osdl.org>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] update checkpatch.pl to version 0.03
Message-ID: <20070607193229.GQ5500@stusta.de>
References: <0a25fd03117c678f17006c5fcefaaed0@pinky> <9a8748490706060205y1fc8e354p4af7426fd76dd816@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <9a8748490706060205y1fc8e354p4af7426fd76dd816@mail.gmail.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2007 at 11:05:07AM +0200, Jesper Juhl wrote:
>...
> - Source files should be 7bit ASCII and Documentation/Kbuild
> files/etc should be UTF-8, test that the patch honors that and doesn't
> put something else in (cleanups that remove 8bit ASCII etc from a
> source file is OK though).
>...

That's wrong:
Code must be 7bit ASCII.
Comments in source files can be UTF-8.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

