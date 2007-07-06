Return-Path: <linux-kernel-owner+w=401wt.eu-S1763028AbXGFHIa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763028AbXGFHIa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 03:08:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762749AbXGFHIU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 03:08:20 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43483 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762181AbXGFHIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 03:08:20 -0400
Date: Fri, 6 Jul 2007 00:08:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Check charset in scripts/checkpatch.pl
Message-Id: <20070706000807.8f9f83ca.akpm@linux-foundation.org>
In-Reply-To: <1183705264.2747.20.camel@shinybook.infradead.org>
References: <1183705264.2747.20.camel@shinybook.infradead.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 06 Jul 2007 03:01:03 -0400 David Woodhouse <dwmw2@infradead.org> wrote:

> Reject all legacy 8-bit character sets and allow only ASCII or UTF-8 to
> be added to files or used in patch descriptions.

What is the reasoning behind this?

> Signed-off-by: David Woodhouse <dwmw2@infradead.org>
> 
> Signed-off-by: asd

Jekyll & Hyde?
