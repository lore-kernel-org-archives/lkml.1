Return-Path: <linux-kernel-owner+w=401wt.eu-S1753627AbYEZGeP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753627AbYEZGeP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 02:34:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751953AbYEZGeE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 02:34:04 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:43516 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751305AbYEZGeD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 02:34:03 -0400
Message-ID: <483A59D7.7020306@garzik.org>
Date: Mon, 26 May 2008 02:33:59 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: POHMELFS high performance network filesystem. Cache coherency,
 transactions, parallels.
References: <20080525134055.GA30630@2ka.mipt.ru> <483A0F3B.9060709@garzik.org> <20080526062204.GA16366@2ka.mipt.ru>
In-Reply-To: <20080526062204.GA16366@2ka.mipt.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Evgeniy Polyakov wrote:
> On Sun, May 25, 2008 at 09:15:39PM -0400, Jeff Garzik (jeff@garzik.org) wrote:
>> Evgeniy Polyakov wrote:
>>> Git tree.
>>> http://tservice.net.ru/~s0mbre/archive/pohmelfs/pohmelfs.git/
>> Is this really the latest commit?
>>
>> commit 21549d0a101c1c9dcdb1fe8d59685415cc0a5e9a
>> Author: Evgeniy Polyakov johnpol@2ka.mipt.ru <zbr@gavana.yandex.ru>
>> Date:   Tue May 13 20:54:49 2008 +0400
>>
>> I would have guessed modifications occurred more recently than May 13.
> 
> No it should be cc4d281eb8d9a4d3a5610acf1558c327358f5725
> Author: Evgeniy Polyakov johnpol@2ka.mipt.ru <zbr@gavana.yandex.ru>
> Date:   Sun May 25 17:24:56 2008 +0400
> 
>     Kconfig entries for cc group and debugging.
>     
> I used 'git push remote_repo' to push data after repository was create, probably I
> should use 'git push --all remote_repo', please try again.

Nope.

Did you forget git-update-server-info, since your method is HTTP?

	Jeff



