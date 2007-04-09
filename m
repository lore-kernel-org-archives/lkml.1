Return-Path: <linux-kernel-owner+w=401wt.eu-S965778AbXDIVKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965778AbXDIVKl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 17:10:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965780AbXDIVKl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 17:10:41 -0400
Received: from inetc.connecttech.com ([64.7.140.42]:3560 "EHLO
	inetc.connecttech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965778AbXDIVKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 17:10:40 -0400
From: "Stuart MacDonald" <stuartm@connecttech.com>
To: <linux-kernel@vger.kernel.org>
Subject: Alternative to 'git bisect visualize'?
Date: Mon, 9 Apr 2007 17:10:23 -0400
Organization: Connect Tech Inc.
Message-ID: <04fe01c77aeb$7d3cd370$294b82ce@stuartm>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook, Build 10.0.6626
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The git mailing list seems to be git-dev, and I can't find a git-users
list anywhere. If there's somewhere better to ask this, please point
me in the right direction.

I've been learning git over the last few days. Specifically, I'm
trying out git bisect to locate a change between 2.6.17 and 2.6.18
that broke something.

I've reached a point where the kernel I build does not boot. Linus
says
http://www.kernel.org/pub/software/scm/git/docs/howto/isolate-bugs-with-bisect.txt
"you should try to find another commit close-by". Other docs I've read
imply this is done with git bisect visualize.

My problem is that I don't have wish/tk installed. Is there a
text-based alternative to visualize that I can use? Or is there a
different method to locate a nearby commit?

The answer may involve something as simple as looking at some git
state; I am a git newbie, and reading the docs hasn't helped any, so I
won't be surprised to find out I'm overlooking something really
obvious.

Thanks in advance for any and all help,
..Stu

