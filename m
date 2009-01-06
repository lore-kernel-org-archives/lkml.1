Return-Path: <linux-kernel-owner+w=401wt.eu-S1753449AbZAFK05@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449AbZAFK05 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 05:26:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751545AbZAFK0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 05:26:34 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:64567 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751373AbZAFK0d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 05:26:33 -0500
Message-ID: <4963319D.8040204@cn.fujitsu.com>
Date: Tue, 06 Jan 2009 18:25:33 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Zdenek Kabelac <zkabelac@redhat.com>
CC: David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org
Subject: Re: [BUG] INFO: inconsistent lock state
References: <4962C322.8000201@cn.fujitsu.com> <49633005.5080305@redhat.com>
In-Reply-To: <49633005.5080305@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zdenek Kabelac wrote:
> Li Zefan napsal(a):
>> I am using Linus' tree, and the top commit is:
>>
>> commit fe0bdec68b77020281dc814805edfe594ae89e0f
>> Merge: 099e657... 5af75d8...
>> Author: Linus Torvalds <torvalds@linux-foundation.org>
>> Date:   Sun Jan 4 16:32:11 2009 -0800
>>
>>     Merge branch 'audit.b61' of
>> git://git.kernel.org/pub/scm/linux/kernel/git/viro/audit-current
>>
>> don't know how I triggered this, and not sure whom to CC, network
>> related?
>>
> 
> I've got the similar one too: http://lkml.org/lkml/2009/1/3/55
> 

So your box freezed and can do nothing but reset ?

I was much luckier that this bug didn't do any harm to my box. :)

