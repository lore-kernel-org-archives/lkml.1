Return-Path: <linux-kernel-owner+w=401wt.eu-S1762494AbYBZJ2v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762494AbYBZJ2v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 04:28:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759918AbYBZJ2n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 04:28:43 -0500
Received: from smtp-102-tuesday.noc.nerim.net ([62.4.17.102]:3194 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759373AbYBZJ2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 04:28:42 -0500
Date: Tue, 26 Feb 2008 10:28:35 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Martin Michlmayr <tbm@cyrius.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Byron Bradley <byron.bbradley@gmail.com>,
       David Brownell <david-b@pacbell.net>
Subject: Re: [GIT PATCH] scsi fixes for 2.6.25-rc2
Message-ID: <20080226102835.5bbab3d1@hyperion.delvare>
In-Reply-To: <20080225223917.GX17231@deprecation.cyrius.com>
References: <1203779614.3139.4.camel@localhost.localdomain>
	<47C08134.2030205@garzik.org>
	<alpine.LFD.1.00.0802231229320.21332@woody.linux-foundation.org>
	<20080225223917.GX17231@deprecation.cyrius.com>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Feb 2008 23:39:17 +0100, Martin Michlmayr wrote:
> * Linus Torvalds <torvalds@linux-foundation.org> [2008-02-23 12:31]:
> > I'm personally of the opinion that a new driver that doesn't add
> > anything but itself (ie no infrastructure changes etc) is fine. I'd
> > rather have a new, rough driver that might work, than no driver at
> > all, and it's not like it can cause a regression if you don't enable
> > it.
> 
> Maybe we can still get the new S-35390A RTC driver in then.  It has
> been acked by Jean Delvare and David Brownell.  Byron or Jean, can you
> try to submit it again?

I'm not the driver author and RTC drivers aren't under my
responsibility. Ask Alessandro Zummo instead.

> It's needed by the QNAP TS-109/TS-209, a NAS device for which support
> has been added in 2.6.25-rc1.

-- 
Jean Delvare
