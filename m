Return-Path: <linux-kernel-owner+w=401wt.eu-S1764288AbXEUPMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764288AbXEUPMY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 11:12:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762758AbXEUPMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 11:12:12 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56628 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761714AbXEUPML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 11:12:11 -0400
Date: Mon, 21 May 2007 16:12:09 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Dave Jones <davej@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, rdunlap@xenotime.net
Subject: Re: RFC: Schedule EFS for removal.
Message-ID: <20070521151209.GA25744@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, rdunlap@xenotime.net
References: <20070521144618.GA6914@redhat.com> <20070521150242.GA25146@infradead.org> <20070521150937.GB6957@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070521150937.GB6957@redhat.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Ok, patch rescinded.  Any opinion on what to do about that bug?
> 
> "use loopback" would be one option I guess.
> Given its been an open bug for four years, there's obviously
> not that much interest in fixing the filesystem.

I don't think it's a bug, it's a lacking feature.  The error message
is quite accurate aswell.
