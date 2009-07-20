Return-Path: <linux-kernel-owner+w=401wt.eu-S1752703AbZGTQtD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703AbZGTQtD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 12:49:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752073AbZGTQtC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 12:49:02 -0400
Received: from mail-01.cse.ucsc.edu ([128.114.48.32]:50410 "EHLO
	mail-01.cse.ucsc.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854AbZGTQtA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 12:49:00 -0400
Date: Mon, 20 Jul 2009 09:49:00 -0700 (PDT)
From: Noah Watkins <jayhawk@soe.ucsc.edu>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Message-ID: <936794064.261051248108540282.JavaMail.root@mail-01.cse.ucsc.edu>
In-Reply-To: <20090720162919.GE2775@tuxdriver.com>
Subject: Re: regression: wireless authentication
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [98.234.142.166]
X-Mailer: Zimbra 5.0.15_GA_2851.RHEL5_64 (ZimbraWebClient - [unknown] (Linux)/5.0.15_GA_2851.RHEL5_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yeh, sorry--I forgot to mention I'm just now getting started
with linux-next, so I haven't successfully used wireless with
linux-next. I began to do a bisect and got preempted by the
weekend.

-n

----- Original Message -----
From: "John W. Linville" <linville@tuxdriver.com>
To: "Noah Watkins" <jayhawk@soe.ucsc.edu>
Cc: linux-next@vger.kernel.org, "LKML" <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, "Stephen Rothwell" <sfr@canb.auug.org.au>
Sent: Monday, July 20, 2009 9:29:19 AM GMT -08:00 US/Canada Pacific
Subject: Re: regression: wireless authentication

On Mon, Jul 20, 2009 at 09:19:00AM -0700, Noah Watkins wrote:
> The latest version I've tried that works fine is Linus' 2.6.31-rc3
> with the latest commit being:
> 
> commit 35b5c55fee08e6e4001ba98060a2d0b82f70b5f4
> Merge: e9e961c... b2dde6a...
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Wed Jul 15 10:29:09 2009 -0700
> 
> I encountered the problem I described when I booted:
> 
> 2.6.31-rc3-next-20090716

That's cool, but it is a bit "apples and oranges"...  What was the
last -next version that was working for you?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
			¡Viva Honduras Libre!
