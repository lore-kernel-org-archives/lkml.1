Return-Path: <linux-kernel-owner+w=401wt.eu-S1759959AbYFLWYk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759959AbYFLWYk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 18:24:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755148AbYFLWYb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 18:24:31 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35462 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755140AbYFLWYa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 18:24:30 -0400
Message-ID: <4851A20D.4070904@sandeen.net>
Date: Thu, 12 Jun 2008 17:24:13 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: xfs-masters@oss.sgi.com
CC: lists@ku-gbr.de, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com
Subject: Re: [xfs-masters] Re: XFS internal error xfs_trans_cancel at line
 1163 of file fs/xfs/xfs_trans.c
References: <20080612123031.21594jyk6rjc1lfk@imp.ku-gbr.de> <6101e8c40806120733m3c8647ccy149eb237e2c6d027@mail.gmail.com>
In-Reply-To: <6101e8c40806120733m3c8647ccy149eb237e2c6d027@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oliver Pinter wrote:
> add CC's
> 
> On 6/12/08, lists@ku-gbr.de <lists@ku-gbr.de> wrote:
>> Hi!
>>
>> Today morning my server at home bailed out two times (reboot between):
>>
>> Jun 12 07:23:40 zappa Filesystem "sda7": XFS internal error
>> xfs_trans_cancel at line 1163 of file fs/xfs/xfs_trans.c.  Caller
>> 0xffffffff802fa8f5
>> Jun 12 07:23:40 zappa Pid: 2379, comm: procmail Not tainted
>> 2.6.25-gentoo-r4 #3
>> Jun 12 07:23:40 zappa
>> Jun 12 07:23:40 zappa Call Trace:
>> Jun 12 07:23:40 zappa [<ffffffff802fa8f5>]
>> Jun 12 07:23:40 zappa [<ffffffff802f4d71>]
>> Jun 12 07:23:40 zappa [<ffffffff802fa8f5>]
>> Jun 12 07:23:40 zappa [<ffffffff803038bb>]
>> Jun 12 07:23:40 zappa [<ffffffff8025f1e1>]
>> Jun 12 07:23:40 zappa [<ffffffff80261899>]
>> Jun 12 07:23:40 zappa [<ffffffff8025ae00>]
>> Jun 12 07:23:40 zappa [<ffffffff80257010>]
>> Jun 12 07:23:40 zappa [<ffffffff80256d92>]
>> Jun 12 07:23:40 zappa [<ffffffff80257077>]
>> Jun 12 07:23:40 zappa [<ffffffff8020ad3b>]

ksymoops please?  hard to divine what those addresses might be.

-Eric
