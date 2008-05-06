Return-Path: <linux-kernel-owner+w=401wt.eu-S1764613AbYEFPYz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764613AbYEFPYz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 11:24:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758798AbYEFPYq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 11:24:46 -0400
Received: from smtp1.wifiinternet.cz ([89.31.47.1]:60248 "EHLO
	bor.wifiinternet.cz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758099AbYEFPYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 11:24:45 -0400
Message-ID: <48207888.3070107@seznam.cz>
Date: Tue, 06 May 2008 17:26:00 +0200
From: Michal Simek <monstr@seznam.cz>
Reply-To: monstr@seznam.cz
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Mike Frysinger <vapier.adi@gmail.com>
CC: Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: Re: LTP for no MMU systems
References: <48206ECF.9090005@seznam.cz> <8bd0f97a0805060749j28cb6fe6wfbdf0d3948d2f417@mail.gmail.com>
In-Reply-To: <8bd0f97a0805060749j28cb6fe6wfbdf0d3948d2f417@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

where is your repo with ltp and tests results?

Thanks,
Michal

>>  I tested Microblaze MMU kernel for finding where could be problem. I have no
>>  problem with compilation. Microblaze MMU test result is on
>>  http://www.monstr.eu/wiki/doku.php?id=kernel:testing.
>>
>>  I would like to test no MMU kernel too. Does anyone use it for no MMU kernel?
>>  (Blackfin, m68k and others)
> 
> yes, we run many of the tests under testcases/kernel/ on Blackfin
> -mike
> 
> 
