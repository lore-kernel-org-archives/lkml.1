Return-Path: <linux-kernel-owner+w=401wt.eu-S934420AbXEHRcw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934420AbXEHRcw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 13:32:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934131AbXEHRcv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 13:32:51 -0400
Received: from mail.syneticon.net ([213.239.212.131]:41911 "EHLO
	mail2.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965337AbXEHRct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 13:32:49 -0400
Message-ID: <4640B3EE.1020707@wpkg.org>
Date: Tue, 08 May 2007 19:31:26 +0200
From: Tomasz Chmielewski <mangoo@wpkg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061110 Mandriva/1.5.0.8-1mdv2007.1 (2007.1) Thunderbird/1.5.0.8 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Lennert Buytenhek <buytenh@wantstofly.org>,
       Alexey Zaytsev <alexey.zaytsev@gmail.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, Michael Jones <mlj28@cam.ac.uk>
Subject: Re: [PATCH] Intel IXP4xx network drivers v.2 - Ethernet and HSS
References: <464034CF.20700@wpkg.org>	<f19298770705080148u70638ac2ue87241382681088@mail.gmail.com>	<m3bqgv72sq.fsf@maximus.localdomain>	<20070508155201.GA1251@xi.wantstofly.org> <m3hcqn5j0p.fsf@maximus.localdomain>
In-Reply-To: <m3hcqn5j0p.fsf@maximus.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Halasa schrieb:
> Lennert Buytenhek <buytenh@wantstofly.org> writes:
> 
>> There _is_ an ARM BE version of Debian.
>>
>> It's not an official port, but it's not maintained any worse than
>> the 'official' LE ARM Debian port is.
> 
> Hmm... That changes a bit. Perhaps we should forget about
> that LE thing then, and (at best) put that trivial workaround?

Does using ixp4xx on LE have any other drawbacks than inferior network 
performance?

And talking about network performance, what numbers are we talking about 
(LE vs BE; 30% performance hit on LE, more, or less)?


-- 
Tomasz Chmielewski
http://wpkg.org
