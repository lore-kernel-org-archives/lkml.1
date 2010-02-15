Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395Ab0BOLVM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 06:21:12 -0500
Received: from bu3sch.de ([62.75.166.246]:43431 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755202Ab0BOLVK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 06:21:10 -0500
From: Michael Buesch <mb@bu3sch.de>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH -mm] ssb: open-code dma_alloc_coherent
Date: Mon, 15 Feb 2010 12:21:04 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
       stefano.brivio@polimi.it, Larry.Finger@lwfinger.net,
       akpm@linux-foundation.org
References: <20100215142111R.fujita.tomonori@lab.ntt.co.jp> <201002151203.42805.mb@bu3sch.de> <20100215201825M.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100215201825M.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201002151221.04758.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 15 February 2010 12:18:41 FUJITA Tomonori wrote:
> You can use the generic DMA API with any buses. I'll remove the PCI
> DMA API in the long term.

Cool. Thanks a lot for cleaning up the mess. *thumbs up*

-- 
Greetings, Michael.
