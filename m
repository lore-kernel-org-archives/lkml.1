Return-Path: <linux-kernel-owner+w=401wt.eu-S1759400AbYBZLQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759400AbYBZLQS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 06:16:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752669AbYBZLQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 06:16:05 -0500
Received: from mx0.towertech.it ([213.215.222.73]:44202 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752506AbYBZLQE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 06:16:04 -0500
Date: Tue, 26 Feb 2008 12:15:52 +0100
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: Jean Delvare <khali@linux-fr.org>
Cc: Martin Michlmayr <tbm@cyrius.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Byron Bradley <byron.bbradley@gmail.com>,
       David Brownell <david-b@pacbell.net>
Subject: Re: [GIT PATCH] scsi fixes for 2.6.25-rc2
Message-ID: <20080226121552.45088e46@i1501.lan.towertech.it>
In-Reply-To: <20080226102835.5bbab3d1@hyperion.delvare>
References: <1203779614.3139.4.camel@localhost.localdomain>
	<47C08134.2030205@garzik.org>
	<alpine.LFD.1.00.0802231229320.21332@woody.linux-foundation.org>
	<20080225223917.GX17231@deprecation.cyrius.com>
	<20080226102835.5bbab3d1@hyperion.delvare>
Organization: Tower Technologies
X-Mailer: Sylpheed
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Feb 2008 10:28:35 +0100
Jean Delvare <khali@linux-fr.org> wrote:


> > * Linus Torvalds <torvalds@linux-foundation.org> [2008-02-23 12:31]:
> > > I'm personally of the opinion that a new driver that doesn't add
> > > anything but itself (ie no infrastructure changes etc) is fine. I'd
> > > rather have a new, rough driver that might work, than no driver at
> > > all, and it's not like it can cause a regression if you don't enable
> > > it.
> > 
> > Maybe we can still get the new S-35390A RTC driver in then.  It has
> > been acked by Jean Delvare and David Brownell.  Byron or Jean, can you
> > try to submit it again?
> 
> I'm not the driver author and RTC drivers aren't under my
> responsibility. Ask Alessandro Zummo instead.

 I'm all ok for inclusion in 2.6.25. I believe the driver
 is in -mm right now, so Andrew might just throw it in?

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

