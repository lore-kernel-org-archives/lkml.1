Return-Path: <linux-kernel-owner+w=401wt.eu-S1751998AbXDTIVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998AbXDTIVT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 04:21:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752395AbXDTIVS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 04:21:18 -0400
Received: from wasp.net.au ([203.190.192.17]:49854 "EHLO wasp.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751998AbXDTIVR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 04:21:17 -0400
Message-ID: <462877E8.2070005@wasp.net.au>
Date: Fri, 20 Apr 2007 12:20:56 +0400
From: Brad Campbell <brad@wasp.net.au>
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: Alex Dubov <oakad@yahoo.com>
CC: Sergey Yanovich <ynvich@gmail.com>, linux-kernel@vger.kernel.org,
       Pierre Ossman <drzeus-mmc@drzeus.cx>
Subject: Re: [mmc] alternative TI FM MMC/SD driver for 2.6.21-rc7
References: <204224.14405.qm@web36703.mail.mud.yahoo.com>
In-Reply-To: <204224.14405.qm@web36703.mail.mud.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Dubov wrote:
> Have you looked at the last version (0.8)? It fixed all outstanding issues (as far as I know).
> 

Seconded. I've been running Alex's latest driver since its release. I routinely suspend/resume 
60-100 times between boots to S3 and disk, I've suspended with cards in the socket and I've tested 
it using SD and MMC .. I've not been able to fault it now. In fact, checking my mail archives, my 
last reported bug was on the 17th of Feb and it has been rock solid since. I just don't think about 
it anymore, it simply works...

Brad
-- 
"Human beings, who are almost unique in having the ability
to learn from the experience of others, are also remarkable
for their apparent disinclination to do so." -- Douglas Adams
