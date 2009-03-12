Return-Path: <linux-kernel-owner+w=401wt.eu-S1755045AbZCLG4O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755045AbZCLG4O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 02:56:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750949AbZCLGz5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 02:55:57 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59466 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751489AbZCLGz4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 02:55:56 -0400
Message-ID: <49B8B1FB.1040506@cn.fujitsu.com>
Date: Thu, 12 Mar 2009 14:55:55 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: anqin <anqin.qin@gmail.com>
CC: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>,
       Vivek Goyal <vgoyal@redhat.com>, oz-kernel@redhat.com,
       paolo.valente@unimore.it, linux-kernel@vger.kernel.org,
       dhaval@linux.vnet.ibm.com, containers@lists.linux-foundation.org,
       menage@google.com, jmoyer@redhat.com, fchecconi@gmail.com,
       arozansk@redhat.com, jens.axboe@oracle.com, akpm@linux-foundation.org,
       fernando@intellilink.co.jp, balbir@linux.vnet.ibm.com
Subject: Re: [RFC] IO Controller
References: <1236823015-4183-1-git-send-email-vgoyal@redhat.com>	 <49B8810B.7030603@oss.ntt.co.jp> <d95d44a20903112340s3c77807dt465e68901747ad89@mail.gmail.com>
In-Reply-To: <d95d44a20903112340s3c77807dt465e68901747ad89@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Please don't top-post...)

anqin wrote:
> Hi Vivek,
> 
> It would be very appreciated if the patches can be based on 2.6.28.
> 

Why? When this is ready to be merged, then it should be based on Jens' block-tree,
or akpm's mm tree. And this version currently is based on 2.6.29-rc4, so if you
want to try it out, just prepare a 2.6.29-rc4 kernel tree.

> Thanks a lot.
> 
> Anqin
> 
> On Thu, Mar 12, 2009 at 11:27 AM, Takuya Yoshikawa
> <yoshikawa.takuya@oss.ntt.co.jp> wrote:
>> Hi Vivek,
>>
>> Could you tell me to which kernel I can apply your patches?
>>   # latest mm?
>> I would like to test your controller.
>>
>> Thank you,
>>   Takuya Yoshikawa
