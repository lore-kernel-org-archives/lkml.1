Return-Path: <linux-kernel-owner+w=401wt.eu-S1764528AbXHHByZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764528AbXHHByZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 21:54:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754184AbXHHByQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 21:54:16 -0400
Received: from waste.org ([66.93.16.53]:42523 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753122AbXHHByP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 21:54:15 -0400
Date: Tue, 7 Aug 2007 20:54:59 -0500
From: Matt Mackall <mpm@selenic.com>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, serue@us.ibm.com
Subject: Re: [RFC][PATCH 2/5] pagemap: use PAGE_MASK/PAGE_ALIGN()
Message-ID: <20070808015458.GI30556@waste.org>
References: <20070807223300.9228E0E0@kernel> <20070807223301.17F179D5@kernel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070807223301.17F179D5@kernel>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2007 at 03:33:01PM -0700, Dave Hansen wrote:
> 
> Use existing macros (PAGE_MASK/PAGE_ALIGN()) instead of
> open-coding them.

Absolutely.

Acked-by: Matt Mackall <mpm@selenic.com>

-- 
Mathematics is the supreme nostalgia of our time.
