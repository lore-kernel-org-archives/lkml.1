Return-Path: <linux-kernel-owner+w=401wt.eu-S933384AbXK3Ar4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933384AbXK3Ar4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 19:47:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761736AbXK3Arn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 19:47:43 -0500
Received: from [222.73.24.84] ([222.73.24.84]:57153 "EHLO song.cn.fujitsu.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756867AbXK3Arn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 19:47:43 -0500
Message-ID: <474F5D15.4090507@cn.fujitsu.com>
Date: Fri, 30 Nov 2007 08:45:09 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Chris Malley <mail@chrismalley.co.uk>
CC: LKML <linux-kernel@vger.kernel.org>, tglx@linutronix.de,
       trivial@kernel.org
Subject: Re: [PATCH 4/6] time: fix typo in comments
References: <1196346715.6461.11.camel@gutsy>
In-Reply-To: <1196346715.6461.11.camel@gutsy>
Content-Type: text/plain; charset=x-user-defined
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>  
>> -/* Suppose we want to devide two numbers NOM and DEN: NOM/DEN, the we can
>> +/* Suppose we want to devide two numbers NOM and DEN: NOM/DEN, then we can
> 
> divide
> 

Yes, I missed it.

>> - * which, buy the way, it can do, but it take more code and at least 2
>> + * which, buy the way, it can do, but it takes more code and at least 2
> 
> by the way 
> (and does this really add anything to the sentence?)
> 

Thanks for pointing it out :)
