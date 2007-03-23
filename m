Return-Path: <linux-kernel-owner+w=401wt.eu-S932368AbXCXJJn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932368AbXCXJJn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2007 05:09:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932406AbXCXJJn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Mar 2007 05:09:43 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4640 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932368AbXCXJJm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2007 05:09:42 -0400
Date: Fri, 23 Mar 2007 22:58:21 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Sergey Smirnov <svs1957@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: HELP!!! SD and suspend damage i-node.
Message-ID: <20070323225820.GA5121@ucw.cz>
References: <4602781C.9060804@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4602781C.9060804@gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> I use 2.6.20.2 kernel with ext3 rootfs on 4Gb SD on sharp zaurus sl-750 (PXA255).
> After suspend/resume filesystem stay clean. But some i-nodes become broken.
> Some files looks like block device or pipe with strange permissions, owner etc.
> I'm sure that there is no bad blocks on SD.
> I'll send any additional information. Just say me what you need to help me.
> I had i lot of tries. Apply patches, remove its, change fstype etc.
> output of fsck -f

How repeatable is the corruption? I have c3000 here, and it corrupts
memory during system, say during one in 5 suspends. Longer suspends
seem to lead to 'more' corruption.

It did not damage my filesystem, yet.

Do you use bluetooth?
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
