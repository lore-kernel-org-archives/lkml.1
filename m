Return-Path: <linux-kernel-owner+w=401wt.eu-S1752302AbZCFGJv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752302AbZCFGJv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 01:09:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751324AbZCFGJk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 01:09:40 -0500
Received: from smtp.nokia.com ([192.100.105.134]:21165 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291AbZCFGJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 01:09:39 -0500
Message-ID: <49B0BE07.5080803@nokia.com>
Date: Fri, 06 Mar 2009 08:09:11 +0200
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reply-To: Artem.Bityutskiy@nokia.com
Organization: Nokia OYJ
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: ext Hannes Eder <hannes@hanneseder.net>
CC: "trivial@kernel.org" <trivial@kernel.org>,
       "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 06/15] NULL noise: drivers/mtd/tests/mtd_*test.c
References: <20090305190954.30062.44759.stgit@f10box.hanneseder.net> <20090305191457.30062.43881.stgit@f10box.hanneseder.net>
In-Reply-To: <20090305191457.30062.43881.stgit@f10box.hanneseder.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 06 Mar 2009 06:09:22.0498 (UTC) FILETIME=[17F81220:01C99E22]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hannes Eder wrote:
> Fix this sparse warnings:
>   drivers/mtd/tests/mtd_oobtest.c:139:33: warning: Using plain integer as NULL pointer
>   drivers/mtd/tests/mtd_oobtest.c:192:33: warning: Using plain integer as NULL pointer
>   drivers/mtd/tests/mtd_oobtest.c:219:41: warning: Using plain integer as NULL pointer
>   drivers/mtd/tests/mtd_oobtest.c:284:25: warning: Using plain integer as NULL pointer
>   drivers/mtd/tests/mtd_oobtest.c:525:25: warning: Using plain integer as NULL pointer
>   drivers/mtd/tests/mtd_oobtest.c:545:25: warning: Using plain integer as NULL pointer
>   drivers/mtd/tests/mtd_oobtest.c:569:33: warning: Using plain integer as NULL pointer
>   drivers/mtd/tests/mtd_oobtest.c:589:33: warning: Using plain integer as NULL pointer
>   drivers/mtd/tests/mtd_oobtest.c:613:33: warning: Using plain integer as NULL pointer
>   drivers/mtd/tests/mtd_oobtest.c:633:33: warning: Using plain integer as NULL pointer
>   drivers/mtd/tests/mtd_oobtest.c:673:41: warning: Using plain integer as NULL pointer
>   drivers/mtd/tests/mtd_oobtest.c:701:33: warning: Using plain integer as NULL pointer
>   drivers/mtd/tests/mtd_readtest.c:74:41: warning: Using plain integer as NULL pointer
> 
> Signed-off-by: Hannes Eder <hannes@hanneseder.net>
> Acked-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

Yes, please, take this patch.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
