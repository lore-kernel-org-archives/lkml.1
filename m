Return-Path: <linux-kernel-owner+w=401wt.eu-S1760562AbXHTVgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760562AbXHTVgg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 17:36:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751702AbXHTVg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 17:36:28 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37249 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751693AbXHTVg1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 17:36:27 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Segher Boessenkool <segher@kernel.crashing.org>
X-Fcc: ~/Mail/linus
Cc: Dave Jones <davej@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [POWERPC] Fix for assembler -g
In-Reply-To: Segher Boessenkool's message of  Monday, 20 August 2007 23:29:46 +0200 <4470f8769f958e0b46eea116ae0e1105@kernel.crashing.org>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20070820213554.2885D4D05F4@magilla.localdomain>
Date: Mon, 20 Aug 2007 14:35:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > In a way though, good thing, or mainline would have continued to be
> > broken :)
> 
> What do I need to do to see this bug, btw?  A special config
> symbol perhaps?

CONFIG_DEBUG_INFO=y
and pass-g-to-assembler-under-config_debug_info.patch from -mm


Thanks,
Roland

