Return-Path: <linux-kernel-owner+w=401wt.eu-S1755276AbYDSX0N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276AbYDSX0N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 19:26:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755173AbYDSXZs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 19:25:48 -0400
Received: from anchor-post-31.mail.demon.net ([194.217.242.89]:4486 "EHLO
	anchor-post-31.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754608AbYDSXZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 19:25:47 -0400
X-Greylist: delayed 496 seconds by postgrey-1.27 at vger.kernel.org; Sat, 19 Apr 2008 19:25:46 EDT
From: fox@crisp.demon.co.uk
To: linux-kernel@vger.kernel.org
Subject: dtrace for linux
Date: Sun, 20 Apr 2008 00:17:28 +0100
User-Agent: Demon-WebMail/2.0
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Message-Id: <E1JnMJE-0001et-Mr@pr-webmail-2.demon.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I would like to announce that I am working on dtrace for Linux.
I have the userland dtrace binary compiled, along with the first
pre-pre-alpha dtracedrv.ko module loaded into my kernel.

Its early days as I work thru the issues but am into stage 3.

Stage 1 was to compile userland dtrace and stage 2 was to compile
the kernel driver. I have lots of stubs and likely bad #defines.

I am trying to improve my makefiles and header dependencies so I
can validate some aspects of kernel portability.

If anyone wants to grab a copy (purely for reference - dont try and
run anything), you can visit 

http://www.crisp.demon.co.uk/tools

and pick up a daily snapshot.

If anyone wants to contribute, feel free - especially if you
feel the approach is wrong etc.

I wont talk about licensing - except to say it will be covered
by the CDDL and not GPL, since its Sun's work and I am simply
deriving, and I am not modifying the kernel (yet).



