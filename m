Return-Path: <linux-kernel-owner+w=401wt.eu-S1763115AbYD0Xih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763115AbYD0Xih (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 19:38:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759832AbYD0Xi2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 19:38:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56824 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755561AbYD0Xi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 19:38:27 -0400
Message-ID: <48150E62.7040508@zytor.com>
Date: Sun, 27 Apr 2008 16:38:10 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Ulrich Drepper <drepper@redhat.com>
CC: Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] eventfd, signalfd, timerfd, epoll_create w/flags
References: <200804272217.m3RMHZ0S021481@devserv.devel.redhat.com> <Pine.LNX.4.64.0804271614240.18184@alien.or.mcafeemobile.com> <48150BDA.5070903@redhat.com> <48150CCE.6050700@zytor.com> <48150D57.5020803@redhat.com>
In-Reply-To: <48150D57.5020803@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ulrich Drepper wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> H. Peter Anvin wrote:
>> But surely these will have to be exposed to the user level somehow?
> 
> You didn't read what I wrote in the first mail.  When I added the
> interface to glibc I already added a flags parameter.  It's just not
> used yet.  So the userlevel interface will not change at all.
> 

Ah, ok.  Sorry.

	-hpa
