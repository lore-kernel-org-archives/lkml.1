Return-Path: <linux-kernel-owner+w=401wt.eu-S1755230AbXH1N7M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230AbXH1N7M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 09:59:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751777AbXH1N67
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 09:58:59 -0400
Received: from ftp.linux-mips.org ([194.74.144.162]:34333 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465AbXH1N66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 09:58:58 -0400
Date: Tue, 28 Aug 2007 14:58:55 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 03/28] Add cmpxchg64 and cmpxchg64_local to mips
Message-ID: <20070828135855.GC31568@linux-mips.org>
References: <20070827155234.062715780@polymtl.ca> <20070827155524.503255159@polymtl.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070827155524.503255159@polymtl.ca>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 27, 2007 at 11:52:37AM -0400, Mathieu Desnoyers wrote:

> Make sure that at least cmpxchg64_local is available on all architectures to use
> for unsigned long long values.

Queued for 2.6.24.  Thanks,

  Ralf
