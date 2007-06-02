Return-Path: <linux-kernel-owner+w=401wt.eu-S1756988AbXFBIlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756988AbXFBIlQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 04:41:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753715AbXFBIlE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 04:41:04 -0400
Received: from mail-in-02.arcor-online.net ([151.189.21.42]:58882 "EHLO
	mail-in-02.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753507AbXFBIlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 04:41:02 -0400
In-Reply-To: <20070601140211.81e5c301.akpm@linux-foundation.org>
References: <20070530235823.793f00d9.akpm@linux-foundation.org> <200705312243.18724.m.kozlowski@tuxland.pl> <20070531141943.5c4d587c.akpm@linux-foundation.org> <200706012250.58962.m.kozlowski@tuxland.pl> <20070601140211.81e5c301.akpm@linux-foundation.org>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <7fa6c0b6701499b0c6cf5aae2a261dc1@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, linux-kernel@vger.kernel.org,
       paulus@samba.org, linuxppc-dev@ozlabs.org,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       Arnd Bergmann <arndb@de.ibm.com>
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: 2.6.22-rc3-mm1
Date: Sat, 2 Jun 2007 10:40:59 +0200
To: Andrew Morton <akpm@linux-foundation.org>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Yeah, allmodconfig tends to fall over in a heap on a lot of the
> less-lavishly-maintained architectures.

To be fair, almost all of the powerpc allmodconfig build
problems are caused by x86-only drivers (and most of those
I doubt still work on x86, even).


Segher

