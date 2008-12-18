Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752409AbYLRHrj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752409AbYLRHrj (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 02:47:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750762AbYLRHr2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 02:47:28 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:49920 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753AbYLRHr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 02:47:27 -0500
Date: Thu, 18 Dec 2008 08:47:15 +0100
From: Pavel Machek <pavel@suse.cz>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Avishay Traeger <avishay@gmail.com>, Jeff Garzik <jeff@garzik.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        open-osd <osd-dev@open-osd.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 8/9] exofs: Documentation
Message-ID: <20081218074714.GC2110@ucw.cz>
References: <4947BFAA.4030208@panasas.com> <4947CB0C.3000406@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4947CB0C.3000406@panasas.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Added some documentation in exofs.txt, as well as a BUGS file.
> 
> For further reading, operation instructions, example scripts
> and up to date infomation and code please see:
> http://open-osd.org
> 
> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>

> +===============================================================================
> +WHAT IS EXOFS?
> +===============================================================================
> +
> +exofs is a file system that uses an OSD and exports the API of a normal Linux
> +file system. Users access exofs like any other local file system, and exofs
> +will in turn issue commands to the local initiator.
> +

Which tells me pretty much nothing. I guess it should explain what is
OSD... there are way too many TLAs and ETLAs in FOSS world.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
