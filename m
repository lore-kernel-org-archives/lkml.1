Return-Path: <linux-kernel-owner+w=401wt.eu-S1423027AbXBAVaO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423027AbXBAVaO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 16:30:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423025AbXBAVaO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 16:30:14 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:21219 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423027AbXBAVaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 16:30:12 -0500
In-Reply-To: <20070201202633.GA14021@outpost.ds9a.nl>
References: <patchbomb.1170193181@tetsuo.zabbo.net> <5bdda0f7bef20427f7e1.1170193185@tetsuo.zabbo.net> <20070201202633.GA14021@outpost.ds9a.nl>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <6F32C88B-8466-4952-8D24-94076FB235DD@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Content-Transfer-Encoding: 7bit
From: Zach Brown <zach.brown@oracle.com>
Subject: Re: [PATCH 4 of 4] Introduce aio system call submission and completion  system calls
Date: Thu, 1 Feb 2007 13:29:41 -0800
To: bert hubert <bert.hubert@netherlabs.nl>
X-Mailer: Apple Mail (2.752.3)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Do you have any userspace code that can be used to get started  
> experimenting
> with your fibril based AIO stuff?

I only have a goofy little test app so far:

	http://www.zabbo.net/~zab/aio-walk-tree.c

It's not to be taken too seriously :)

> I want to try it on from a userspace perspective.

Frankly, I'm not sure its ready for that yet.  You're welcome to give  
it a try, but it's early enough that you're sure to hit problems  
almost immediately.

- z
