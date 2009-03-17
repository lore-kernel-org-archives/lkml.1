Return-Path: <linux-kernel-owner+w=401wt.eu-S1754608AbZCQO3f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608AbZCQO3f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 10:29:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752091AbZCQO3Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 10:29:25 -0400
Received: from smtp.nokia.com ([192.100.105.134]:21969 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733AbZCQO3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 10:29:24 -0400
Message-ID: <49BFB351.6020301@nokia.com>
Date: Tue, 17 Mar 2009 16:27:29 +0200
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reply-To: Artem.Bityutskiy@nokia.com
Organization: Nokia OYJ
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Hannes Eder <hannes@hanneseder.net>,
       "trivial@kernel.org" <trivial@kernel.org>,
       "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-mtd@lists.infradead.org
Subject: Re: [PATCH v2 06/15] NULL noise: drivers/mtd/tests/mtd_*test.c
References: <20090305190954.30062.44759.stgit@f10box.hanneseder.net> <20090305191457.30062.43881.stgit@f10box.hanneseder.net> <49B0BE07.5080803@nokia.com> <alpine.LNX.2.00.0903171421200.11733@jikos.suse.cz>
In-Reply-To: <alpine.LNX.2.00.0903171421200.11733@jikos.suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 17 Mar 2009 14:27:32.0002 (UTC) FILETIME=[820BB020:01C9A70C]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina wrote:
>>>   drivers/mtd/tests/mtd_oobtest.c:673:41: warning: Using plain integer as
>>> NULL pointer
>>>   drivers/mtd/tests/mtd_oobtest.c:701:33: warning: Using plain integer as
>>> NULL pointer
>>>   drivers/mtd/tests/mtd_readtest.c:74:41: warning: Using plain integer as
>>> NULL pointer
>>>
>>> Signed-off-by: Hannes Eder <hannes@hanneseder.net>
>>> Acked-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
>> Yes, please, take this patch.
> 
> Doesn't seem to be present in current -next/-mmotim, applied to trivial
> tree.

Fine with me. (CCed linux-mtd).

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
