Return-Path: <linux-kernel-owner+w=401wt.eu-S1763044AbXIKLOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763044AbXIKLOR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 07:14:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757957AbXIKLOF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 07:14:05 -0400
Received: from 74-93-104-98-Washington.hfc.comcastbusiness.net ([74.93.104.98]:49127
	"EHLO picasso.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1760713AbXIKLOF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 07:14:05 -0400
Date: Tue, 11 Sep 2007 04:13:50 -0700 (PDT)
Message-Id: <20070911.041350.70219297.davem@davemloft.net>
To: kovedi@gmail.com
Cc: linux-kernel@vger.kernel.org, stable-bounces@kernel.org,
       davem@sunset.davemloft.net
Subject: Re: [Sparc64 BUG] hangup under booting 2.6.22.X whith Sparc64
From: David Miller <davem@davemloft.net>
In-Reply-To: <406fe6c90709102233m2472e6c4h7d329a3f64692645@mail.gmail.com>
References: <406fe6c90709100442j1ae0ef79v3188eb10b8be451b@mail.gmail.com>
	<20070910.053642.71114977.davem@davemloft.net>
	<406fe6c90709102233m2472e6c4h7d329a3f64692645@mail.gmail.com>
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Kövedi_Krisztián" <kovedi@gmail.com>
Date: Tue, 11 Sep 2007 07:33:13 +0200

> thanks, we find one kernel panic under initailizin the pci deveces
> 
> hier is the dmesg with -p:

Thanks, we're getting closer to figuring out the cause,
but we need some more information.

Can you send me the output of "/usr/sbin/prtconf -pv"
from a working boot?  Thanks!
