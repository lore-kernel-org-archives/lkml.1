Return-Path: <linux-kernel-owner+w=401wt.eu-S1753160AbZKJNen@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160AbZKJNen (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 08:34:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751258AbZKJNem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 08:34:42 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33918 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029AbZKJNem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 08:34:42 -0500
Date: Tue, 10 Nov 2009 14:34:47 +0100
From: Pavel Machek <pavel@ucw.cz>
To: mobi phil <mobi@mobiphil.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Fwd: eifs/fmfs (everything is filesystem/file mapping filesystem)
Message-ID: <20091110133447.GE26144@atrey.karlin.mff.cuni.cz>
References: <a4875c0e0911091128g3920726bk2e20be67920dc483@mail.gmail.com> <a4875c0e0911100417j1a9fba09tce5da4a5511111c0@mail.gmail.com> <a4875c0e0911100424h947058bg5c7efc6e2d7d817c@mail.gmail.com> <a4875c0e0911100426t2e95cf21g8bbad12438804ef6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4875c0e0911100426t2e95cf21g8bbad12438804ef6@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I am not sure about the best name, but I am sure it is sthg. very
> usefull. So I will call it mobifs, hope you do not mind :) I am also
> not sure if there is sthg. like that out there, but based on my 15
> years of linux experience I never met sthg. like what I would like to
> talk about.
> 
> What I would like to have on my linux boxes is to access data the following way:
> 
> #>cat /dev/sda1@/partition1/etc/inittab@/defaultranlevel #usecase 0

google fuse
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
