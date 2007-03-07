Return-Path: <linux-kernel-owner+w=401wt.eu-S1161162AbXCGBnt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161162AbXCGBnt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 20:43:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161176AbXCGBns
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 20:43:48 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:42326 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161175AbXCGBnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 20:43:47 -0500
X-AuthUser: davidel@xmailserver.org
Date: Tue, 6 Mar 2007 17:43:45 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 1/4] signalfd v1 - signalfd core ...
In-Reply-To: <Pine.LNX.4.64.0703061639370.3661@alien.or.mcafeemobile.com>
Message-ID: <Pine.LNX.4.64.0703061741560.3661@alien.or.mcafeemobile.com>
References: <Pine.LNX.4.64.0703061639370.3661@alien.or.mcafeemobile.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Mar 2007, Davide Libenzi wrote:

> This patch series implements a new signalfd() system call. I took part of 
> the original Linus code (and you know how badly it can be broken :), and I 
> added even more breakage ;)

I forgot to add that this requires the anonymous inode source contained in 
the previously posted epoll patch set.



- Davide


