Return-Path: <linux-kernel-owner+w=401wt.eu-S1754929AbZBWO2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929AbZBWO2R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 09:28:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753407AbZBWO2C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 09:28:02 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:53890 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752884AbZBWO2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 09:28:01 -0500
To: xiyou.wangcong@gmail.com
CC: rjw@sisk.pl, linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       miklos@szeredi.hu
In-reply-to: <20090222135818.GA12782@hack.private> (message from
	=?utf-8?Q?Am=C3=A9rico?= Wang on Sun, 22 Feb 2009 21:58:18 +0800)
Subject: Re: [Bug #12208] uml is very slow on 2.6.28 host
References: <sTyoMUwdm9B.A.QCH.U40lJB@chimera> <ROx6X68CGJG.A.Y3B.t50lJB@chimera> <20090222135818.GA12782@hack.private>
Message-Id: <E1Lbbml-0002ww-BW@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 23 Feb 2009 15:27:55 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Feb 2009, =?utf-8?Q?Am=C3=A9rico?= Wang wrote:
> On Sat, Feb 14, 2009 at 09:50:19PM +0100, Rafael J. Wysocki wrote:
> >This message has been generated automatically as a part of a report
> >of regressions introduced between 2.6.27 and 2.6.28.
> >
> >The following bug entry is on the current list of known regressions
> >introduced between 2.6.27 and 2.6.28.  Please verify if it still should
> >be listed and let me know (either way).
> >
> >
> >Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12208
> >Subject		: uml is very slow on 2.6.28 host
> >Submitter	: Miklos Szeredi <miklos@szeredi.hu>
> >Date		: 2008-12-12 9:35 (65 days old)
> >References	: http://marc.info/?l=linux-kernel&m=122907463518593&w=4
> 
> Hello, Miklos!
> 
> I can't reproduce this on host 2.6.28.7 with uml guest of current git.
> Have you tried 2.6.28.7? Does it have the same problem?

It's still slow for me on 2.6.29-rc5.  I haven't tried 2.6.28.7 yet.

Thanks,
Miklos
