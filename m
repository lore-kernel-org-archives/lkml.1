Return-Path: <linux-kernel-owner+w=401wt.eu-S1755740AbZB0FIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755740AbZB0FIW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 00:08:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751341AbZB0FIL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 00:08:11 -0500
Received: from smtp.nokia.com ([192.100.105.134]:46587 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbZB0FIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 00:08:10 -0500
Message-ID: <49A77503.8040900@nokia.com>
Date: Fri, 27 Feb 2009 07:07:15 +0200
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reply-To: Artem.Bityutskiy@nokia.com
Organization: Nokia OYJ
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Hannes Eder <hannes@hanneseder.net>
CC: "trivial@kernel.org" <trivial@kernel.org>,
       "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/16] MTD: tests: fix sparse warnings: Using plain 	integer
 as NULL pointer
References: <20090221235706.17557.97714.stgit@vmbox.hanneseder.net>	 <20090222000216.17557.92413.stgit@vmbox.hanneseder.net> <154e089b0902261702r52432481q6a0561de9576ed71@mail.gmail.com>
In-Reply-To: <154e089b0902261702r52432481q6a0561de9576ed71@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 27 Feb 2009 05:07:23.0022 (UTC) FILETIME=[4618D2E0:01C99899]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hannes Eder wrote:
> [Added To]
> 
> On Sun, Feb 22, 2009 at 1:02 AM, Hannes Eder <hannes@hanneseder.net> wrote:
>> Fix this sparse warnings:
>>  drivers/mtd/tests/mtd_oobtest.c:139:33: warning: Using plain integer as NULL pointer
>>  drivers/mtd/tests/mtd_oobtest.c:192:33: warning: Using plain integer as NULL pointer
>>  drivers/mtd/tests/mtd_oobtest.c:219:41: warning: Using plain integer as NULL pointer
>>  drivers/mtd/tests/mtd_oobtest.c:284:25: warning: Using plain integer as NULL pointer
>>  drivers/mtd/tests/mtd_oobtest.c:525:25: warning: Using plain integer as NULL pointer
>>  drivers/mtd/tests/mtd_oobtest.c:545:25: warning: Using plain integer as NULL pointer
>>  drivers/mtd/tests/mtd_oobtest.c:569:33: warning: Using plain integer as NULL pointer
>>  drivers/mtd/tests/mtd_oobtest.c:589:33: warning: Using plain integer as NULL pointer
>>  drivers/mtd/tests/mtd_oobtest.c:613:33: warning: Using plain integer as NULL pointer
>>  drivers/mtd/tests/mtd_oobtest.c:633:33: warning: Using plain integer as NULL pointer
>>  drivers/mtd/tests/mtd_oobtest.c:673:41: warning: Using plain integer as NULL pointer
>>  drivers/mtd/tests/mtd_oobtest.c:701:33: warning: Using plain integer as NULL pointer
>>  drivers/mtd/tests/mtd_readtest.c:74:41: warning: Using plain integer as NULL pointer
>>
>> Signed-off-by: Hannes Eder <hannes@hanneseder.net>

Acked-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
