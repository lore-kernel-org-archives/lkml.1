Return-Path: <linux-kernel-owner+w=401wt.eu-S1754509Ab0ARNBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754509Ab0ARNBR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 08:01:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752863Ab0ARNBK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 08:01:10 -0500
Received: from casper.infradead.org ([85.118.1.10]:45261 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752851Ab0ARNBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 08:01:07 -0500
Subject: Re: [perfmon2] [PATCH] perf: fix the is_software_event() definition
From: Peter Zijlstra <peterz@infradead.org>
To: eranian@gmail.com
Cc: Frederic Weisbecker <fweisbec@gmail.com>, perfmon2-devel@lists.sf.net,
       linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>,
       paulus@samba.org, mingo@elte.hu, davem@davemloft.net
In-Reply-To: <7c86c4471001180453ueed2839n27f9e44d86ee003d@mail.gmail.com>
References: <4b4c761b.0338560a.1eaa.ffff824d@mx.google.com>
	 <1263312616.4244.153.camel@laptop>
	 <bd4cb8901001130154p732672b6x56e758c1ab33a8e8@mail.gmail.com>
	 <1263400193.4244.238.camel@laptop>
	 <bd4cb8901001130852y1de007cbqe66d77605c1ec372@mail.gmail.com>
	 <bd4cb8901001130922s7ad85af6w6c631d90de177ef9@mail.gmail.com>
	 <20100117141233.GF5035@nowhere> <1263813189.4283.245.camel@laptop>
	 <1263815616.4283.332.camel@laptop>
	 <7c86c4471001180453ueed2839n27f9e44d86ee003d@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Jan 2010 14:00:56 +0100
Message-ID: <1263819656.4283.471.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-01-18 at 13:53 +0100, stephane eranian wrote:

> PERF_TYPE_HW_CACHE is a hardware PMU event.

D'0h!

