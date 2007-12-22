Return-Path: <linux-kernel-owner+w=401wt.eu-S1752717AbXLVFBm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717AbXLVFBm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 00:01:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750813AbXLVFBe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 00:01:34 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52217 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750796AbXLVFBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 00:01:33 -0500
Date: Fri, 21 Dec 2007 21:00:58 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: Matt Mackall <mpm@selenic.com>, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: 2.6.24-rc5-mm1: problems with cat /proc/kpageflags
Message-Id: <20071221210058.b30fef27.akpm@linux-foundation.org>
In-Reply-To: <200712212251.46397.m.kozlowski@tuxland.pl>
References: <20071220.045359.107684960.davem@davemloft.net>
	<20071220.161726.68534356.davem@davemloft.net>
	<20071221010653.GA19691@waste.org>
	<200712212251.46397.m.kozlowski@tuxland.pl>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Dec 2007 22:51:45 +0100 Mariusz Kozlowski <m.kozlowski@tuxland.pl> wrote:

> > Here's a test patch:
> 
> Tested on 2.6.23 and 2.6.24-rc5-mm1. The patch fixes the bug.
> 
> Thanks a lot to both of you.

Thank you for testing -mm (especially on sparc64) and for reporting
the bug and for testing the fix.
