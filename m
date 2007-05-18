Return-Path: <linux-kernel-owner+w=401wt.eu-S1755492AbXERPCN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492AbXERPCN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 11:02:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755135AbXERPB7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 11:01:59 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:58729 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754665AbXERPB7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 11:01:59 -0400
Date: Fri, 18 May 2007 17:01:51 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: maxk@qualcomm.com, bluez-devel@lists.sourceforge.net,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [oops] in bluetooth
Message-ID: <20070518150151.GA2735@elf.ucw.cz>
References: <20070518141342.GA3692@elf.ucw.cz> <1179497988.10069.198.camel@violet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1179497988.10069.198.camel@violet>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > I played with rfcomm here -- I'm trying to emulate bluetooth gps using
> > normal pc -- and got couple of oopses.
> > 
> > pavel@amd:~$ uname -a
> > Linux amd 2.6.21 #421 SMP Fri Apr 27 15:06:54 CEST 2007 i686 GNU/Linux
> > pavel@amd:~$
> > 
> 
> can you try with 2.6.22-rc1. I have seen this before, but never actually
> found the root cause for it. It might be inside the sysfs layer.

I'm afraid it is not reproducible :-(.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
