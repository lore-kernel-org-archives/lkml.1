Return-Path: <linux-kernel-owner+w=401wt.eu-S1750797AbXBMQIx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750797AbXBMQIx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 11:08:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750807AbXBMQIx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 11:08:53 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55792 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797AbXBMQIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 11:08:52 -0500
Date: Tue, 13 Feb 2007 16:08:49 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Artem Bityutskiy <dedekind@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>,
       Andreas Arnez <arnez@vnet.ibm.com>,
       Frank Haverkamp <haver@vnet.ibm.com>
Subject: Re: Pull UBI tree
Message-ID: <20070213160849.GB22748@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Artem Bityutskiy <dedekind@infradead.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Josh Boyer <jwboyer@linux.vnet.ibm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	David Woodhouse <dwmw2@infradead.org>,
	Andreas Arnez <arnez@vnet.ibm.com>,
	Frank Haverkamp <haver@vnet.ibm.com>
References: <1171380852.17314.55.camel@sauron>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1171380852.17314.55.camel@sauron>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 13, 2007 at 05:34:12PM +0200, Artem Bityutskiy wrote:
> Hello Linus,
> 
> The UBI tree has been in -mm for a few releases now and we would like to
> to see it in the mainline.

Please send out a current version for review instead.  Last time I looked
at it lots of things looked quite over-engineered, and I'd like to check
if this has been improved since.

