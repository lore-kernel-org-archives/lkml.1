Return-Path: <linux-kernel-owner+w=401wt.eu-S932672AbXCFGhZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932672AbXCFGhZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 01:37:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933961AbXCFGhZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 01:37:25 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:38316 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932672AbXCFGhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 01:37:24 -0500
X-AuthUser: davidel@xmailserver.org
Date: Mon, 5 Mar 2007 22:37:23 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Eric Dumazet <dada1@cosmosbay.com>
cc: "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch v2] epoll use a single inode ...
In-Reply-To: <Pine.LNX.4.64.0703052230300.4907@alien.or.mcafeemobile.com>
Message-ID: <Pine.LNX.4.64.0703052236010.4907@alien.or.mcafeemobile.com>
References: <Pine.LNX.4.64.0703051532590.4907@alien.or.mcafeemobile.com>
 <Pine.LNX.4.64.0703051558070.3998@woody.linux-foundation.org>
 <Pine.LNX.4.64.0703051609430.4907@alien.or.mcafeemobile.com>
 <Pine.LNX.4.64.0703051621590.3998@woody.linux-foundation.org>
 <45ECD122.6020907@zytor.com> <Pine.LNX.4.64.0703051832260.4907@alien.or.mcafeemobile.com>
 <45ECD3D4.5020305@zytor.com> <Pine.LNX.4.64.0703051841380.4907@alien.or.mcafeemobile.com>
 <45ED08A9.9050501@cosmosbay.com> <Pine.LNX.4.64.0703052230300.4907@alien.or.mcafeemobile.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Mar 2007, Davide Libenzi wrote:

> This would be used for epoll, signalfd and timerfd. And the printf format 
> is %llu ;)

Today is really one on those days ... %llx



- Davide


