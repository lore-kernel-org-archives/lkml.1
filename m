Return-Path: <linux-kernel-owner+w=401wt.eu-S1757065AbZGBWeB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757065AbZGBWeB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 18:34:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756121AbZGBWdz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 18:33:55 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60604 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755022AbZGBWdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 18:33:54 -0400
Date: Fri, 3 Jul 2009 00:33:49 +0200
From: Pavel Machek <pavel@ucw.cz>
To: tridge@samba.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, john.lanza@linux.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Steve French <sfrench@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] Added CONFIG_VFAT_FS_DUALNAMES option
Message-ID: <20090702223349.GA30840@elf.ucw.cz>
References: <19013.8005.541836.436991@samba.org> <20090630063102.GB1351@ucw.cz> <200907012019.53932.rusty@rustcorp.com.au> <20090702214646.GD1485@ucw.cz> <19021.12158.915384.574218@samba.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19021.12158.915384.574218@samba.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2009-07-03 08:06:54, tridge@samba.org wrote:
> Hi Pavel,
> 
>  > > I disagree with this: given there's been testing with no known issues, it's 
>  > > not a back compat question.
>  > 
>  > The testing uncovered some pretty serious issues. ('Causes XP to
>  > bluescreen').
> 
> no, that's not quite correct. I have never been able to produce a
> bluescreen with the patch I have posted.

So you know it causes XP to bluescreen, but can not reproduce that. So
what? Someone, somewhere _will_ reproduce it.
										Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
