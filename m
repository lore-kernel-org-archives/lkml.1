Return-Path: <linux-kernel-owner+w=401wt.eu-S1762693AbYCDKPD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762693AbYCDKPD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 05:15:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752777AbYCDKOy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 05:14:54 -0500
Received: from brick.kernel.dk ([87.55.233.238]:23546 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752679AbYCDKOy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 05:14:54 -0500
Date: Tue, 4 Mar 2008 11:14:51 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: yshi <yang.shi@windriver.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix DMA access of block device in 64-bit kernel on some non-x86  systems with 4GB or upper 4GB memory
Message-ID: <20080304101450.GJ6704@kernel.dk>
References: <47CD179B.3000806@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47CD179B.3000806@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 04 2008, yshi wrote:
> For some non-x86 systems with 4GB or upper 4GB memory,
> we need increase the range of addresses that can be
> used for direct DMA in 64-bit kernel.

Looks good, applied.

-- 
Jens Axboe

