Return-Path: <linux-kernel-owner+w=401wt.eu-S1032332AbXEHV2O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032332AbXEHV2O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 17:28:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031838AbXEHV2K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 17:28:10 -0400
Received: from smtp105.sbc.mail.mud.yahoo.com ([68.142.198.204]:30820 "HELO
	smtp105.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1031825AbXEHV2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 17:28:08 -0400
X-YMail-OSG: p9inHyEVM1l4pmJkca5ySlX1cHNwN0YUpEEZSMY5hvsmV9ehgHrZ2AIxD3k3K6w1dltbvIyWsw--
Date: Tue, 8 May 2007 14:28:03 -0700
From: Chris Wedgwood <cw@f00f.org>
To: linux-kernel@vger.kernel.org
Cc: Andi Kleen <ak@suse.de>
Subject: Re: [PATCH] [x86-64] Add getcpu and epoll_pwait system calls.
Message-ID: <20070508212803.GA4156@tuatara.stupidest.org>
References: <20070508185145.B9A8E1827261@tuatara.stupidest.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070508185145.B9A8E1827261@tuatara.stupidest.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2007 at 11:37:26AM -0700, Chris Wedgwood wrote:

> +#define __NR_getcpu		280

I see something was merged just now that uses 280.  Should I resubmit
this using 281 & 282?
