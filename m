Return-Path: <linux-kernel-owner+w=401wt.eu-S1754215AbZALKCd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215AbZALKCd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 05:02:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752041AbZALKCZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 05:02:25 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46246 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856AbZALKCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 05:02:25 -0500
Date: Mon, 12 Jan 2009 11:02:23 +0100
From: Pavel Machek <pavel@suse.cz>
To: ???? <wxc200@gmail.com>
Cc: ?ric Piel <eric.piel@tremplin-utc.net>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: hp accelerometer: fix LED handling and add freefall detection
Message-ID: <20090112100223.GC20053@atrey.karlin.mff.cuni.cz>
References: <20090112092839.GA2190@elf.ucw.cz> <496B0E5F.1020902@tremplin-utc.net> <fd6b62c10901120150q6b00640dm72c0ec5d0bd7a9e2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fd6b62c10901120150q6b00640dm72c0ec5d0bd7a9e2@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>    Hi,
>    Very good work.

Thanks :-).

>    Really hard to get accurate accelerometer data by sensor,
>    there need some emulation for sensor like your work.
>    I am using lis331 in our phone. :)

Fortunately, HP is doing most of the work for us.
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
