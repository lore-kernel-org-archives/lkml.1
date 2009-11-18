Return-Path: <linux-kernel-owner+w=401wt.eu-S1751883AbZKRHS7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751883AbZKRHS7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 02:18:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751680AbZKRHS6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 02:18:58 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51282
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751510AbZKRHS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 02:18:57 -0500
Date: Tue, 17 Nov 2009 23:19:14 -0800 (PST)
Message-Id: <20091117.231914.75564159.davem@davemloft.net>
To: rjw@sisk.pl
Cc: linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       bzolnier@gmail.com, manty@manty.net
Subject: Re: [Bug #14294] kernel BUG at drivers/ide/ide-disk.c:187
From: David Miller <davem@davemloft.net>
In-Reply-To: <OWmO9uyC1hM.A.NaC.6ndALB@chimera>
References: <ipicVA1QUFF.A.zWB.1mdALB@chimera>
	<OWmO9uyC1hM.A.NaC.6ndALB@chimera>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Rafael J. Wysocki" <rjw@sisk.pl>
Date: Tue, 17 Nov 2009 00:01:20 +0100 (CET)

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
> Date		: 2009-09-30 11:05 (48 days old)
> References	: http://marc.info/?l=linux-kernel&m=125430926311466&w=4
> Handled-By	: David Miller <davem@davemloft.net>

Santiago, have you hit this again since moving to newer kernels?

Thanks!
