Return-Path: <linux-kernel-owner+w=401wt.eu-S1763406AbXHJHpk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763406AbXHJHpk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 03:45:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760048AbXHJHpW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 03:45:22 -0400
Received: from canuck.infradead.org ([209.217.80.40]:51005 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758444AbXHJHpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 03:45:20 -0400
Subject: Re: [PATCH] [MTD] Fix CFI build error with meaningless
	nonfunctional .config
From: David Woodhouse <dwmw2@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070810074140.GB28264@elte.hu>
References: <20070806161537.GA1269@elte.hu>
	 <1186717841.7282.104.camel@shinybook.infradead.org>
	 <20070810074140.GB28264@elte.hu>
Content-Type: text/plain
Date: Fri, 10 Aug 2007 15:45:02 +0800
Message-Id: <1186731902.3571.1.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-3.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-08-10 at 09:41 +0200, Ingo Molnar wrote:
> looks quite quirky. Is there no Kconfig-space solution for this?

I thought about that, but decided against it. We have altogether too
much munging of config options without the user's knowledge already; I
didn't want to make it worse.

-- 
dwmw2

