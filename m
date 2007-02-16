Return-Path: <linux-kernel-owner+w=401wt.eu-S1946116AbXBPUTL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946116AbXBPUTL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 15:19:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946120AbXBPUTL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 15:19:11 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:41558 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946116AbXBPUTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 15:19:10 -0500
Date: Fri, 16 Feb 2007 15:11:21 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Michael Richardson <mcr@sandelman.ca>
Cc: linux-kernel@vger.kernel.org
Subject: Re: failure of cache_alloc_refill to terminate
Message-ID: <20070216201121.GA8222@ccure.user-mode-linux.org>
References: <er4pev$bv$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <er4pev$bv$1@sea.gmane.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 16, 2007 at 12:25:26PM -0500, Michael Richardson wrote:
> (Yes, I suspect that the slab got corrupted.)

Is slab debugging turned on?

			Jeff

-- 
Work email - jdike at linux dot intel dot com
