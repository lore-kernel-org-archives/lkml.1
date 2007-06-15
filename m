Return-Path: <linux-kernel-owner+w=401wt.eu-S1756021AbXFOMn4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756021AbXFOMn4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 08:43:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753379AbXFOMnq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 08:43:46 -0400
Received: from ns1.suse.de ([195.135.220.2]:47394 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753082AbXFOMnp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 08:43:45 -0400
From: Andi Kleen <ak@suse.de>
To: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] Introduce compat_u64 and compat_s64 types
Date: Fri, 15 Jun 2007 14:40:09 +0200
User-Agent: KMail/1.9.1
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Airlie <airlied@linux.ie>, linux-arch@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
References: <200706150159.l5F1xNgM000459@hera.kernel.org> <200706151355.57464.ak@suse.de> <200706151403.53855.arnd@arndb.de>
In-Reply-To: <200706151403.53855.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706151440.10273.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> That is broken on all non-x86 architectures, 

It cannot be broken, it just might be somewhat slower

-Andi
