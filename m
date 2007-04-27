Return-Path: <linux-kernel-owner+w=401wt.eu-S1755490AbXD0InN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490AbXD0InN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 04:43:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755489AbXD0InM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 04:43:12 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:53983 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755488AbXD0InK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 04:43:10 -0400
Subject: Re: "REPORT: sd-0.46 vs cfs-v6 vs mainline 2.6.21-rc7 Beryl +
	Video + Audio"
From: Kasper Sandberg <lkml@metanurb.dk>
To: hechacker1 <hechacker1@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <6700d24e0704262101v132bec29nf9fd6c93fe8748a@mail.gmail.com>
References: <6700d24e0704262101v132bec29nf9fd6c93fe8748a@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 27 Apr 2007 10:42:04 +0200
Message-Id: <1177663324.29963.4.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.4.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-04-26 at 21:01 -0700, hechacker1 wrote:
<snip>
> Overall:
> SD-0.46 is my new choice for scheduler. When not under load everything
> run's better or similarly to cfs or mainline. Under load however it
> shows the most responsiveness.
> 
> Occasionally I had complete mouse freezes with cfs when the system was
> busy. But rarely.
> 
> Under SD i haven't seen anything get starved.
> 
> mainline surprisingly works better than i expected, but beryl suffers
> and responsiveness suffers under load.

Your findings seems somewhat similar to mine, what i have observed is
that SD is much more smooth, with vanilla/cfs, under just abit load
opengl stuff will stutter, whereas with sd it will simply get
slightly(or more, depending on the load) lower fps.

> 
> --hechacker1
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

