Return-Path: <linux-kernel-owner+w=401wt.eu-S1759299AbYGFUUr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759299AbYGFUUr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 16:20:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754754AbYGFUUj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 16:20:39 -0400
Received: from bu3sch.de ([62.75.166.246]:57808 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753133AbYGFUUj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 16:20:39 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [PATCH v2] gpiolib: Allow user-selection
Date: Sun, 6 Jul 2008 22:20:05 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
       David Brownell <david-b@pacbell.net>
References: <200807031233.04229.mb@bu3sch.de> <200807062201.25194.mb@bu3sch.de> <20080706201346.GG21669@cs181140183.pp.htv.fi>
In-Reply-To: <20080706201346.GG21669@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807062220.05527.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 06 July 2008 22:13:46 Adrian Bunk wrote:
> A defconfig is just a normal .config and cannot override any dependencies.
> 
> CONFIG_ARCH_REQUIRE_GPIOLIB is not user visible and defaults to n, so if 
> no option select's it then even using a defconfig that has it enabled 
> will result in a .config that has it disabled.

Ok, thanks a lot for explaining this to me. :)

-- 
Greetings Michael.
