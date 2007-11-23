Return-Path: <linux-kernel-owner+w=401wt.eu-S1756226AbXKWKam@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226AbXKWKam (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 05:30:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754069AbXKWKaf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 05:30:35 -0500
Received: from verein.lst.de ([213.95.11.210]:34479 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753442AbXKWKae (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 05:30:34 -0500
Date: Fri, 23 Nov 2007 11:30:21 +0100
From: Christoph Hellwig <hch@lst.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jeremy Kerr <jk@ozlabs.org>, linux-kernel@vger.kernel.org,
       cbe-oss-dev@ozlabs.org
Subject: Re: [Cbe-oss-dev] [RFC/PATCH] Export force_sig_info
Message-ID: <20071123103021.GB13189@lst.de>
References: <1194845812.531937.269801315194.qpush@pokey> <20071122234141.087743fa.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071122234141.087743fa.akpm@linux-foundation.org>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 22, 2007 at 11:41:41PM -0800, Andrew Morton wrote:
> Perhaps export it from within a powerpc-specific C file (along with
> suitable comment) to prevent people from generally relying upon the export?

Yes, please.  I don't like this beeing exported at all.

