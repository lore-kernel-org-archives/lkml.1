Return-Path: <linux-kernel-owner+w=401wt.eu-S936420AbXHGW51@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936420AbXHGW51 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 18:57:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934695AbXHGW5E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 18:57:04 -0400
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:2312 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934515AbXHGW5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 18:57:00 -0400
Date: Wed, 8 Aug 2007 01:56:35 +0300
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Andi Kleen <ak@suse.de>,
       riku.seppala@kymp.net, Andy Whitcroft <apw@shadowen.org>,
       Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH/RFT] finish i386 and x86-64 sysdata conversion
Message-ID: <20070807225635.GJ4278@rhun.haifa.ibm.com>
References: <46B3A7BB.9000102@redhat.com> <200708041130.42038.ak@suse.de> <20070804093222.f0d7f3c7.akpm@linux-foundation.org> <200708050140.49590.ak@suse.de> <20070805050410.GB4960@rhun.haifa.ibm.com> <86802c440708042238h39fa1b4ude2836fd9732213b@mail.gmail.com> <20070805075307.GA25890@rhun.haifa.ibm.com> <20070807154911.5fe93b40.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070807154911.5fe93b40.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2007 at 03:49:11PM -0700, Andrew Morton wrote:

> I am sooooooo tired of this thing.  Andi, someone, can we for heaven's
> sake please just get it all sorted out?

With regards to the sysdata conversion: Riku says he cannot test new
kernel. I haven't heard anything from Andy Whitcroft. It passes all of
my tests and what we have now is obviously broken... I think we should
put the fix in.

Cheers,
Muli
