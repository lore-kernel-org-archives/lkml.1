Return-Path: <linux-kernel-owner+w=401wt.eu-S1758927AbYEYTzV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758927AbYEYTzV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 15:55:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755806AbYEYTzG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 15:55:06 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:54033 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755289AbYEYTzF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 15:55:05 -0400
Message-ID: <4839C414.3070504@garzik.org>
Date: Sun, 25 May 2008 15:55:00 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: POHMELFS high performance network filesystem. Cache coherency,
 transactions, parallels.
References: <20080525134055.GA30630@2ka.mipt.ru>
In-Reply-To: <20080525134055.GA30630@2ka.mipt.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Evgeniy Polyakov wrote:
>  * Client parallel extensions: ability to write to multiple servers and
> 	balance reading between them. Code was imported to the current version,
> 	but not enabled yet.
>  * Client dynamical server reconfiguration: ability to add/remove servers
> 	from working set by server command and from userspace.

Neat :)


> 2. Source archive.
> http://tservice.net.ru/~s0mbre/archive/pohmelfs/
> Git tree.
> http://tservice.net.ru/~s0mbre/archive/pohmelfs/pohmelfs.git/

Is the server available via git?

http://tservice.net.ru/~s0mbre/archive/pohmelfs/server/ does not include 
history information, etc.

	Jeff


