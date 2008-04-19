Return-Path: <linux-kernel-owner+w=401wt.eu-S1759406AbYDSNW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759406AbYDSNW2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 09:22:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754282AbYDSNWW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 09:22:22 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50137 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753823AbYDSNWV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 09:22:21 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: 2.6.25-git1: Solid hang on HP nx6325 (64-bit)
Date: Sat, 19 Apr 2008 15:22:53 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804191522.54334.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2.6.25-git1 hung solid  on my HP nx6325 when I was trying to run KMail.

That happened after running it for several hours with a couple of suspend
and hibernation cycles in between, but I hadn't been doing anything unusual
with it.

Well, that has never happened since 2.6.25-rc1 (at least) on this box, so it
looks worrisome.  I guess one of the x86 changes is responsible for it.

Thanks,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
