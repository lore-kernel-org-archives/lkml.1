Return-Path: <linux-kernel-owner+w=401wt.eu-S1764850AbXLUAf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764850AbXLUAf3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 19:35:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755916AbXLUAfR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 19:35:17 -0500
Received: from ozlabs.org ([203.10.76.45]:58563 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752332AbXLUAfQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 19:35:16 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 2/5] dma_map_sg_ring() helper
Date: Fri, 21 Dec 2007 11:35:12 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: davem@davemloft.net, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, jens.axboe@oracle.com
References: <20071220160631S.fujita.tomonori@lab.ntt.co.jp> <200712210958.56994.rusty@rustcorp.com.au> <20071221090027K.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20071221090027K.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712211135.13150.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 21 December 2007 11:00:27 FUJITA Tomonori wrote:
> We need to pass the whole sg entries to the IOMMUs at a time.

Hi Fujita,

    OK, it's certainly possible to have an arch override.  For which 
architecture is this BTW?

Thanks,
Rusty.


