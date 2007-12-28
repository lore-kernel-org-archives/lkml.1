Return-Path: <linux-kernel-owner+w=401wt.eu-S1752718AbXL1S75@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718AbXL1S75 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 13:59:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751299AbXL1S7r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 13:59:47 -0500
Received: from verein.lst.de ([213.95.11.210]:38933 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751287AbXL1S7q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 13:59:46 -0500
Date: Fri, 28 Dec 2007 19:58:32 +0100
From: Christoph Hellwig <hch@lst.de>
To: Arnd Bergmann <ARNDB@de.ibm.com>
Cc: Stefano Brivio <stefano.brivio@polimi.it>,
       Johannes Berg <johannes@sipsolutions.net>,
       Akinobu Mita <akinobu.mita@gmail.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Mattias Nissler <mattias.nissler@gmx.de>,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       hch@lst.de
Subject: Re: [PATCH v4 7/8] debugfs: allow access to signed values
Message-ID: <20071228185832.GA4462@lst.de>
References: <20071219001955.055692620@polimi.it> <1198080034.4747.15.camel@johannes.berg> <20071220131548.1d09cd62@morte> <200712201347.15022.ARNDB@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712201347.15022.ARNDB@de.ibm.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2007 at 01:47:13PM +0100, Arnd Bergmann wrote:
> Also, Christoph has recently posted a suggestion for how to improve
> the interface to allow the 'get' operation to return an error:
> http://patchwork.ozlabs.org/cbe-oss-dev/patch?id=14962
> 
> I'd suggest consolidating the two changes in order to avoid merge
> conflicts.

Stefano, I couldn't find your complete patch series.  Where are the
other 7 patches for that series?   Anyway, I'll post my series with
the simple attribute chanegs ASAP and I'll Cc you.  If you send me the
latest version of your patches I'll port it ontop of my patches.
