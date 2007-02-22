Return-Path: <linux-kernel-owner+w=401wt.eu-S1945967AbXBVLEB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945967AbXBVLEB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 06:04:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945966AbXBVLEA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 06:04:00 -0500
Received: from raven.upol.cz ([158.194.120.4]:51485 "EHLO raven.upol.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945965AbXBVLEA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 06:04:00 -0500
To: Neil Brown <neilb@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: loops (Re: [PATCH 006 of 6] md: Add support for reshape of a raid6)
In-Reply-To: <17885.636.133245.572876@notabene.brown>
References: <20070220172544.15678.patches@notabene> <1070220063516.16208@suse.de> <20070221144806.e6eed85c.akpm@linux-foundation.org> <17885.636.133245.572876@notabene.brown>
Date: Thu, 22 Feb 2007 12:13:17 +0100
Message-Id: <E1HKBsz-0001Am-OR@flower>
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Neil Brown
> Newsgroups: gmane.linux.raid,gmane.linux.kernel
> Subject: Re: [PATCH 006 of 6] md: Add support for reshape of a raid6
> Date: Thu, 22 Feb 2007 13:39:56 +1100
[]
> I guess...  "Egoless programmer" and all that, "write for others to
> read, not for the compiler",

Few years back on AVR GCC uC architecture, suggested by me
do {...} while(--i) resulted to different numbers of loops with
different optimization levels...

Compilers are written by humans anyway.
____
