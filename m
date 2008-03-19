Return-Path: <linux-kernel-owner+w=401wt.eu-S936504AbYCSWt5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936504AbYCSWt5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 18:49:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765506AbYCSVTI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 17:19:08 -0400
Received: from el-out-1112.google.com ([209.85.162.179]:64364 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965819AbYCSVTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 17:19:07 -0400
Message-ID: <47E0B46C.6030302@gmail.com>
Date: Wed, 19 Mar 2008 15:36:28 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Jan Kasprzak <kas@fi.muni.cz>
CC: =?UTF-8?B?TWFsdGUgU2NocsO2ZGVy?= <maltesch@gmx.de>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: Regression: kernel 2.6.24{,.1} ahci problem, does not boot (resend)
References: <20080214184700.0bd3837d@highlander.home.lan> <47B4D02E.9030101@gmail.com> <20080215191215.430ee2e0@highlander.home.lan> <47BCE71F.2000309@gmail.com> <20080221172757.44882428@highlander.home.lan> <20080317210045.GG3189@fi.muni.cz> <20080318140116.GC8480@fi.muni.cz> <47E08762.9090704@gmail.com> <20080319061958.GK3189@fi.muni.cz>
In-Reply-To: <20080319061958.GK3189@fi.muni.cz>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kasprzak wrote:
> Tejun Heo wrote:
> : Hmm... I still wanna know why it got broke in the first place.  The only
> : thing I can think of is IRQ routing problem in which case pci=nomsi or
> : irqpoll should help.  Any chance you can test the old BIOS?
> 
> 	Yes, I can. What data are you interested in? Boot logs with
> pci=nomsi and irqpoll ? Anything else?

pci=nomsi, then, irqpoll should be enough for now.

Thanks.

-- 
tejun
