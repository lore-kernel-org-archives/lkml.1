Return-Path: <linux-kernel-owner+w=401wt.eu-S1758442AbYERPio@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758442AbYERPio (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 11:38:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757325AbYERPic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 11:38:32 -0400
Received: from sandeen.net ([209.173.210.139]:24260 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757346AbYERPib (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 11:38:31 -0400
Message-ID: <48304D77.1090803@sandeen.net>
Date: Sun, 18 May 2008 10:38:31 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.14 (Macintosh/20080421)
MIME-Version: 1.0
To: David Greaves <david@dgreaves.com>
CC: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com,
       "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>,
       LinuxRaid <linux-raid@vger.kernel.org>
Subject: Re: Regression- XFS won't mount on partitioned md array
References: <482DC043.5000307@dgreaves.com> <482DD981.5070004@sandeen.net> <482EEFDA.50101@dgreaves.com> <482EF6A7.2020909@sandeen.net> <482F67D9.70400@sandeen.net> <482FBD4C.20608@sandeen.net> <482FED60.7060405@dgreaves.com>
In-Reply-To: <482FED60.7060405@dgreaves.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Greaves wrote:
> Eric Sandeen wrote:


> mmmm
> 'little buglets' in the filesystem holding a few Tb of data...
> mmmm
> Anything I can do to help find that? I suspect not if you can reproduce it.

Nah.  I'll ask the sgi guys about it, it just seems a little
inconsistent but maybe by design...

-Eric

> Anyhow - thanks again.
> 
> David
> PS I'll be back soon, back in 2.6.23 I was hitting a hibernate/xfs bug which
> I've been avoiding by powering down. Well, it's still there in 2.6.25.3...
> 

