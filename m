Return-Path: <linux-kernel-owner+w=401wt.eu-S1761324AbYGOCKV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761324AbYGOCKV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 22:10:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752189AbYGOCKJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 22:10:09 -0400
Received: from ik-out-1112.google.com ([66.249.90.176]:17554 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754531AbYGOCKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 22:10:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=awnTkXOgA6TXrm0Q340stosyG+qnoYA4sZBKeQ4N/T1oYb7EcFPo4JNIZvB/MdkwOY
         bmPBw4uoKtPJJQhNEe4J4O7x//gPxXm3brB4tDFyuxRes4k5+s4y1MIFT1jSOH9LkjyM
         UR+VvhMcv8V+OUwwNtrEw1o+l3PiFT7ggiwsA=
Message-ID: <6d291e080807141910m573b29b2t753ea7c4db09902d@mail.gmail.com>
Date: Mon, 14 Jul 2008 21:10:03 -0500
From: "Stoyan Gaydarov" <stoyboyker@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: From 2.4 to 2.6 to 2.7?
Cc: torvalds@linux-foundation.org, "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       gorcunov@gmail.com, akpm@linux-foundation.org, mingo@elte.hu
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First things first, I would like to know what prompted the change from
2.4 to 2.6 kernels. I know that the change had to do with the
development version, the 2.5 tree and the massive amounts of patches
distros had to carry. Aside from this i think it was also the
scheduler changes that prompted the 2.6 version, but I don't know all
that much about it and any other comments about the change would be
great.

Second I wanted to talk about the linux 2.7.x kernel, whats in the
making or maybe even not started, that could prompt a change to a 2.7
version kernel, i know that a lot of good changes are going into the
kernel as part of the rcX kernels in the 2.6 version. Would we
continue to see 2.6 kernels until some big problem shows its head and
we all go "oh sh**" and then change something so massive that it
prompts the change or are we going to continue with the 2.6 tree. I
just want to get some information and peoples opinions on this, just
to see where things are headed.

-Stoyan G
