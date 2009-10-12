Return-Path: <linux-kernel-owner+w=401wt.eu-S1756130AbZJLKve@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756130AbZJLKve (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 06:51:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756058AbZJLKve
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 06:51:34 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47091
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754797AbZJLKvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 06:51:33 -0400
Date: Mon, 12 Oct 2009 03:51:26 -0700 (PDT)
Message-Id: <20091012.035126.264745627.davem@davemloft.net>
To: rjw@sisk.pl
Cc: linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       bzolnier@gmail.com, manty@manty.net
Subject: Re: [Bug #14294] kernel BUG at drivers/ide/ide-disk.c:187
From: David Miller <davem@davemloft.net>
In-Reply-To: <L6tb-VyKHZK.A.xEC.dzl0KB@chimera>
References: <56acieJJ2fF.A.nEB.Hzl0KB@chimera>
	<L6tb-VyKHZK.A.xEC.dzl0KB@chimera>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Rafael J. Wysocki" <rjw@sisk.pl>
Date: Mon, 12 Oct 2009 01:01:09 +0200 (CEST)

> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.30 and 2.6.31.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.30 and 2.6.31.  Please verify if it still should
> be listed and let me know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14294
> Subject		: kernel BUG at drivers/ide/ide-disk.c:187
> Submitter	: Santiago Garcia Mantinan <manty@manty.net>
> Date		: 2009-09-30 11:05 (12 days old)
> References	: http://marc.info/?l=linux-kernel&m=125430926311466&w=4
> Handled-By	: David Miller <davem@davemloft.net>

I gave the user a debugging patch, but they reported that they
can no longer trigger the issue with 2.6.31.1

See:

	http://marc.info/?l=linux-ide&m=125469615425454&w=4

Maybe that's enough to close this, I dunno.
