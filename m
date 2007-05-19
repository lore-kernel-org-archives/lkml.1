Return-Path: <linux-kernel-owner+w=401wt.eu-S1759904AbXESJyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759904AbXESJyR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 05:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754767AbXESJyJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 05:54:09 -0400
Received: from aun.it.uu.se ([130.238.12.36]:65413 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754560AbXESJyI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 05:54:08 -0400
Date: Sat, 19 May 2007 11:53:45 +0200 (MEST)
Message-Id: <200705190953.l4J9rjO2024613@harpo.it.uu.se>
From: Mikael Pettersson <mikpe@it.uu.se>
To: segher@kernel.crashing.org
Subject: gcc-4.2.0 breakage on powerpc?
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 May 2007 01:39:43 +0200, Segher Boessenkool wrote:
>> and we'll end up
>> having major kernel releases which don't build on i386 with major gcc
>> releases, which isn't altogether desirable.
>
>Yeah, like 4.2.0 with powerpc.  Seems like no one tested it :-(

Details please. What exactly are the gcc-4.2.0 problems on powerpc?

/Mikael
