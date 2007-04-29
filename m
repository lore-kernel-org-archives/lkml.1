Return-Path: <linux-kernel-owner+w=401wt.eu-S1161482AbXD2VwY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161482AbXD2VwY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 17:52:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161489AbXD2VwX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 17:52:23 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:58580 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161482AbXD2VwW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 17:52:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=OCkIxWYL5pxGELXiSZwn1diYzB12ApJP9ANdFPB6M2vacfPAdzYvgj3qiGw09F2IHERq5L/Zt7DfJeywgYEAE/5jLJ3Wasejyx0h8sLOsu/QRtaTLh9PP6HSbwt+GB6RJSq/YgOBBF2O5uidJSN7+2VFZdPgF9CmYPxDOisCiCA=
Date: Sun, 29 Apr 2007 23:51:47 +0200
From: Diego Calleja <diegocg@gmail.com>
To: Adrian Bunk <bunk@stusta.de>
Cc: Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21
Message-Id: <20070429235147.06a94dfa.diegocg@gmail.com>
In-Reply-To: <20070429211028.GT3468@stusta.de>
References: <20070428224904.GE3468@stusta.de>
	<alpine.LFD.0.98.0704281601060.9964@woody.linux-foundation.org>
	<p73d51n1fup.fsf@bingen.suse.de>
	<alpine.LFD.0.98.0704290848360.9964@woody.linux-foundation.org>
	<20070429173500.GA30248@one.firstfloor.org>
	<alpine.LFD.0.98.0704291040580.9964@woody.linux-foundation.org>
	<20070429180909.GA30604@one.firstfloor.org>
	<20070429214007.9ea12e96.diegocg@gmail.com>
	<20070429201729.GQ3468@stusta.de>
	<20070429225657.a501ab5a.diegocg@gmail.com>
	<20070429211028.GT3468@stusta.de>
X-Mailer: Sylpheed version 2.3.0beta5 (GTK+ 2.10.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

El Sun, 29 Apr 2007 23:10:28 +0200, Adrian Bunk <bunk@stusta.de> escribió:

> What exactly is the purpose of the 2.6.21 regressions list in the Wiki?

AFAIK, submitting its contents to the list periodically CCing the developers,
like you did with your lists.

If developers care to fix it or not or how much Linus cares about that list before
releasing a new version is another question. I think it's useful because it makes
those bugs look more important than the 1600 stored in the bugzilla...it won't
help to fix those 1600, but it attracts some attention over the "release critical"
ones and encourages developers to fix them, even if not all of them get fixed.

I don't think you can do many other things to get as much bugs fixed as possible,
unless we reward bug fixers with weekends in the Playboy mansion. I think the
fundamental question here is: is there a way to make hackers follow and fix _all_
the bugs? I'd love it was possible, but AFAIK all the projects that have tried to
be ultra-stable and have adopted a policy to fullfill such goal have fallen behind
of competing projects that cared more about working in improving their software.
