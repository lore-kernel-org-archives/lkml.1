Return-Path: <linux-kernel-owner+w=401wt.eu-S1754589AbYHDNmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589AbYHDNmS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 09:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753043AbYHDNmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 09:42:09 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39002 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752627AbYHDNmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 09:42:08 -0400
Subject: Re: [PATCH 3/4] Fix remaining big endian issue of hfcmulti
From: David Woodhouse <dwmw2@infradead.org>
To: Karsten Keil <kkeil@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       isdn4linux@listserv.isdn4linux.de, linux-kernel@vger.kernel.org
In-Reply-To: <20080802151532.DE017A3C09@pingi.kke.suse.de>
References: <20080802151532.DE017A3C09@pingi.kke.suse.de>
Content-Type: text/plain
Date: Mon, 04 Aug 2008 13:03:59 +0100
Message-Id: <1217851439.3454.605.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-08-02 at 16:35 +0200, Karsten Keil wrote:
> The driver was not so bad at big endian at all, only the optimised fifo
> read/write functions need a fix, with this fix the driver works on
> a pegasus PPC machine.

Great; thanks.

And the ztdummy parts? 

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation



