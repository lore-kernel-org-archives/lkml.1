Return-Path: <linux-kernel-owner+w=401wt.eu-S1757401AbZLWWVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757401AbZLWWVV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 17:21:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755932AbZLWWVU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 17:21:20 -0500
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:45138 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754157AbZLWWVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 17:21:19 -0500
Date: Thu, 24 Dec 2009 01:21:16 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       netdev@vger.kernel.org, leoli@freescale.com
Subject: Re: ucc_geth broken in 2.6.32 by
 864fdf884e82bacbe8ca5e93bd43393a61d2e2b4
Message-ID: <20091223222116.GA851@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20091223174019.GB762@caffeine.csclub.uwaterloo.ca>
 <20091223180415.GA12987@oksana.dev.rtsoft.ru>
 <20091223200948.GF760@caffeine.csclub.uwaterloo.ca>
 <20091223202226.GA8185@oksana.dev.rtsoft.ru>
 <20091223221047.GH760@caffeine.csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20091223221047.GH760@caffeine.csclub.uwaterloo.ca>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 23, 2009 at 05:10:47PM -0500, Lennart Sorensen wrote:
[...]
> That seems to be it.  It works now.  No more crashes.
> Those two patches together seem to do the trick.

Great!

> I really hope they
> can go into 2.6.32-stable then, since this is a regression over 2.6.31
> and is hopefully an obvious fix.

Yep, will try to get them there.

Thanks a lot for helping to track this down,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
