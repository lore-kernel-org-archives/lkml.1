Return-Path: <linux-kernel-owner+w=401wt.eu-S932806AbZACURy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932806AbZACURy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 15:17:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759361AbZACURn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 15:17:43 -0500
Received: from mail01a.mail.t-online.hu ([84.2.40.6]:53471 "EHLO
	mail01a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759042AbZACURm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 15:17:42 -0500
X-Greylist: delayed 677 seconds by postgrey-1.27 at vger.kernel.org; Sat, 03 Jan 2009 15:17:41 EST
Subject: Grsecurity is about to be discontinued, unless...
From: Gabor MICSKO <gmicsko@gmail.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Sat, 03 Jan 2009 21:06:16 +0100
Message-Id: <1231013176.6497.20.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
X-DCC-mail.t-online.hu-Metrics: mail01a.mail.t-online.hu 32720; Body=3 Fuz1=3
	Fuz2=3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

As most of you probably know, a GPL licensed security solution called
grsecurity [1] has been available for the Linux kernel since a while. It
has a rather impressive list of features [2]. The lead developer has
been maintaining patches for the 2.4 and the 2.6 branch for many years.

According to their developers, the patch includes various advanced
security aspects which inspired several further projects [3].

A week ago, the latest - and probably the last - release was published.
The main developer lost its sole sponsor due to the financial crisis, so
the future of the project is in danger. As a result, the future
development of PaX [4], one of the definitive components of grsecurity
is also in deep trouble [5].

In the past, there have been several requests toward the Linux
developers to include grsecurity and PaX in the mainline kernel
[6][7][8], but in vain.

The common opinion of the developers of grsecurity, PaX and their users
is that acceptance of the code into the kernel would be the best
solution for saving the project, beside finding another long-term
sponsor.

Before the project would finally die, I would like to draw your
attention to the question of integration into the kernel again.

In short, I would like to know what is your answer to this request. And
in the case if you see no chance for the integration, I would like to
know what is the reason behind this decision.

[1] http://www.grsecurity.net
[2] http://www.grsecurity.net/features.php
[3] http://grsecurity.net/~spender/grsecurity_pax-influence.png
[4] http://pax.grsecurity.net/
[5] http://www.grsecurity.net/news.php#grsec2112
[6] http://lkml.org/lkml/2003/4/20/13
[7] http://lkml.indiana.edu/hypermail/linux/net/0602.0/0020.html
[8] http://lkml.org/lkml/2005/1/13/184


Thanks and best regards,


-- 
Gabor MICSKO - http://hup.hu

