Return-Path: <linux-kernel-owner+w=401wt.eu-S933583AbZJLXV2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933583AbZJLXV2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 19:21:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933572AbZJLXV2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 19:21:28 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40185
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933571AbZJLXV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 19:21:26 -0400
Date: Mon, 12 Oct 2009 16:21:22 -0700 (PDT)
Message-Id: <20091012.162122.61258418.davem@davemloft.net>
To: manty@manty.net
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       bzolnier@gmail.com
Subject: Re: [Bug #14294] kernel BUG at drivers/ide/ide-disk.c:187
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091012120943.GA2625@dis.manty.net>
References: <L6tb-VyKHZK.A.xEC.dzl0KB@chimera>
	<20091012.035126.264745627.davem@davemloft.net>
	<20091012120943.GA2625@dis.manty.net>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Santiago Garcia Mantinan <manty@manty.net>
Date: Mon, 12 Oct 2009 14:09:43 +0200

> I'm now back to the 2.6.31 with the patch to debug it (3 days uptime) in
> order to gather more info and after I get the info from 2.6.31 I'd test
> 3.6.31.latest or even 2.6.32whatever in case you find that better.

Ok, thanks for the update.
