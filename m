Return-Path: <linux-kernel-owner+w=401wt.eu-S1752939AbYKYI0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752939AbYKYI0T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 03:26:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751885AbYKYI0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 03:26:08 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:41556 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760AbYKYI0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 03:26:06 -0500
Date: Tue, 25 Nov 2008 03:26:03 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Markus Metzger <markus.t.metzger@intel.com>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       tglx@linutronix.de, markus.t.metzger@gmail.com, roland@redhat.com,
       akpm@linux-foundation.org, mtk.manpages@gmail.com,
       eranian@googlemail.com, juan.villacis@intel.com
Subject: Re: [patch 7/9] x86, pebs: export ds.c symbols
Message-ID: <20081125082603.GB28031@infradead.org>
References: <20081125090847.A31384@sedona.ch.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081125090847.A31384@sedona.ch.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2008 at 09:08:47AM +0100, Markus Metzger wrote:
> Export symbols in ds.c.
> 
> The changes are required to allow perfmon2 to access DS.

So put them into the perform2 patchset.

