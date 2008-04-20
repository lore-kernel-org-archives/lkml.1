Return-Path: <linux-kernel-owner+w=401wt.eu-S1760086AbYDTANF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760086AbYDTANF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 20:13:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753660AbYDTAMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 20:12:55 -0400
Received: from cpc4-cbly1-0-0-cust583.glfd.cable.ntl.com ([86.16.162.72]:54790
	"EHLO crisp.demon.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753403AbYDTAMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 20:12:54 -0400
X-Greylist: delayed 3362 seconds by postgrey-1.27 at vger.kernel.org; Sat, 19 Apr 2008 20:12:54 EDT
From: paul <fox@crisp.demon.co.uk>
Message-Id: <200804192316.m3JNGoTZ019800@crisp.demon.co.uk>
Reply-To: fox@crisp.demon.co.uk
To: linux-kernel@vger.kernel.org
Subject: dtrace for linux
X-CRiSP-MessageID: 20080420-001
X-Mailer: Created by CRiSP-Mail v3.2 (CRiSP v9.3.3b)
Date: Sun, 20 Apr 2008 00:13:09 +0000
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

