Return-Path: <linux-kernel-owner+w=401wt.eu-S1755870AbYDJJIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755870AbYDJJIS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 05:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754864AbYDJJIF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 05:08:05 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2482 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750820AbYDJJIE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 05:08:04 -0400
Date: Wed, 9 Apr 2008 23:09:07 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Tomasz Chmielewski <mangoo@wpkg.org>
Cc: LKML <linux-kernel@vger.kernel.org>, penberg@cs.helsinki.fi,
       =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
       ext-adrian.hunter@nokia.com, jwboyer@gmail.com,
       "Artem B. Bityutskiy" <dedekind@yandex.ru>
Subject: Re: UBIFS vs Logfs (was [RFC PATCH] UBIFS - new flash file system)
Message-ID: <20080409210907.GA9683@ucw.cz>
References: <47F1EC20.6050600@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47F1EC20.6050600@wpkg.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> For me, the motivators to wait for LogFS are mainly the 
> facts that it
> can work on traditional block devices, and not only on 
> pure flash:
> 
> 1. It works on normal block devices and it supports 
> transparent compression
> 
> Today, a 64 GB SSD/flash-based media costs ~about the 
> same as a 1 TB
> hard disk. This makes flash very expensive to use; 
> compression can
> compensate that cost a bit (will depend on the usage, of 
> course).
> 
> I believe there is no other Linux filesystem which can 
> do transparent
> compression on block devices.

I'd like compressed filesystem for maps and lingvistic data... but
will the flash flesystems have 'reasonable' performance when used on
harddrive?
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
