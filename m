Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754371Ab0BARrE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 12:47:04 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:40409 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091Ab0BARrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 12:47:01 -0500
Subject: Re: [PATCH] perf_events: fix bug in hw_perf_enable()
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
       davem@davemloft.net, fweisbec@gmail.com, robert.richter@amd.com,
       perfmon2-devel@lists.sf.net, eranian@gmail.com,
       Arjan van de Ven <arjan@linux.intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <bd4cb8901002010923q79fa82f5s90a8430b4c037a19@mail.gmail.com>
References: <4b66dc67.0b38560a.1635.ffffae18@mx.google.com>
	 <1265038508.24455.177.camel@laptop> <1265040260.24455.200.camel@laptop>
	 <bd4cb8901002010814x12e5a26v195f13c63b0f7567@mail.gmail.com>
	 <1265042731.24455.232.camel@laptop>
	 <bd4cb8901002010923q79fa82f5s90a8430b4c037a19@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 01 Feb 2010 18:46:51 +0100
Message-ID: <1265046411.24455.235.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-02-01 at 18:23 +0100, Stephane Eranian wrote:
> >  244235699509090  raw 0x13c
> >  244235695558036  raw 0x13c
> >
> Strange. I am running mine on a Q6600.
> What's yours? 

These numbers came from a T9400, but my Q9450 does something similar.

