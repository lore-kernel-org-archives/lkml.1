Return-Path: <linux-kernel-owner+w=401wt.eu-S932079AbXBSLAo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932079AbXBSLAo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 06:00:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932077AbXBSLAo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 06:00:44 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55020 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932073AbXBSLAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 06:00:43 -0500
Date: Mon, 19 Feb 2007 11:00:36 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Artem Bityutskiy <dedekind@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 09/44 take 2] [UBI] debug unit header
Message-ID: <20070219110036.GD16930@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Artem Bityutskiy <dedekind@infradead.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Frank Haverkamp <haver@vnet.ibm.com>,
	Josh Boyer <jwboyer@linux.vnet.ibm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	David Woodhouse <dwmw2@infradead.org>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain> <20070217165509.5845.12977.sendpatchset@localhost.localdomain> <200702172218.22709.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702172218.22709.arnd@arndb.de>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 17, 2007 at 10:18:21PM +0100, Arnd Bergmann wrote:
> On Saturday 17 February 2007 17:55, Artem Bityutskiy wrote:
> > +
> > +/**
> > + * UBI debugging unit.
> > + *
> > + * UBI provides rich debugging capabilities which are implemented in
> > + * this unit.
> 
> Stop right here. You should be doing one thing and do it right.
> Since the point of your patches is to do volume management for MTD,
> it should do just that.
> 
> If you feel that Linux needs rich debugging capabilities, then submit
> a patch for that independent of UBI.
> 

*nod*
