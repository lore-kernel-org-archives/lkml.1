Return-Path: <linux-kernel-owner+w=401wt.eu-S932461AbXCEWlI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932461AbXCEWlI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 17:41:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932495AbXCEWlH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 17:41:07 -0500
Received: from smtp.osdl.org ([65.172.181.24]:39909 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932487AbXCEWk6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 17:40:58 -0500
Date: Mon, 5 Mar 2007 14:40:52 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Gene Heskett <gene.heskett@gmail.com>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Lee Revell" <rlrevell@joe-job.com>,
       "Nicolas Mailhot" <nicolas.mailhot@laposte.net>
Subject: Re: [ANNOUNCE] RSDL completely fair starvation free interactive cpu
 scheduler
Message-Id: <20070305144052.82a67511.akpm@linux-foundation.org>
In-Reply-To: <200703051419.25814.gene.heskett@gmail.com>
References: <54348.192.54.193.51.1173087934.squirrel@rousalka.dyndns.org>
	<200703050453.08154.gene.heskett@gmail.com>
	<75b66ecd0703051020h1f0c1f85r15a5de082a80cec0@mail.gmail.com>
	<200703051419.25814.gene.heskett@gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 05 Mar 2007 14:19:25 -0500
Gene Heskett <gene.heskett@gmail.com> wrote:

> Andrew, please, get this one in ASAP,

I'm presently nearly 1000 messages behind on my lkml reading.  We'll get
there.

> but promise me an -mm won't trash 
> half my filesystems like one I tried 2-3 years ago did.

I can't.  -mm is crap at present.  Well.  Mainline is crap at present, and
-mm is crap^2.  I think I might be about to throw vast amounts of code
overboard.


