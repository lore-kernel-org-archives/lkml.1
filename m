Return-Path: <linux-kernel-owner+w=401wt.eu-S1756137AbXKTAzc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137AbXKTAzc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 19:55:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752081AbXKTAzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 19:55:21 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42823
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752654AbXKTAzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 19:55:20 -0500
Date: Mon, 19 Nov 2007 16:55:19 -0800 (PST)
Message-Id: <20071119.165519.164684482.davem@davemloft.net>
To: eranian@hpl.hp.com
Cc: paulus@samba.org, hch@infradead.org, akpm@linux-foundation.org,
       gregkh@suse.de, mucci@cs.utk.edu, wcohen@redhat.com,
       robert.richter@amd.com, linux-kernel@vger.kernel.org,
       andi@firstfloor.org
Subject: Re: [perfmon] Re: [perfmon2] perfmon2 merge news
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071119205330.GD27571@frankl.hpl.hp.com>
References: <20071114.172722.71465976.davem@davemloft.net>
	<20071119.050843.48408777.davem@davemloft.net>
	<20071119205330.GD27571@frankl.hpl.hp.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephane Eranian <eranian@hpl.hp.com>
Date: Mon, 19 Nov 2007 12:53:30 -0800

> In anycase, I would be happy to integrate your sparc64 patches.

I sent these to Philip Mucci late last night, but in the meantime
I finished implementing breakpoint support as well for pfmon.

Let me clean up my diffs and I'll send it all out to you in a
few hours.
