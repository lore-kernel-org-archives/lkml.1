Return-Path: <linux-kernel-owner+w=401wt.eu-S938629AbXHICpg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938629AbXHICpg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 22:45:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763105AbXHICp1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 22:45:27 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:49742 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760974AbXHICp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 22:45:27 -0400
Date: Thu, 9 Aug 2007 03:45:24 +0100
From: Christoph Hellwig <hch@infradead.org>
To: J??rn Engel <joern@logfs.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
       akpm@osdl.org, David Woodhouse <dwmw2@infradead.org>,
       Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Patch 18/18] include/linux/Kbuild
Message-ID: <20070809024524.GB18792@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	J??rn Engel <joern@logfs.org>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
	akpm@osdl.org, David Woodhouse <dwmw2@infradead.org>,
	Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>
References: <20070808161234.GB15319@lazybastard.org> <20070808162447.GT15319@lazybastard.org> <20070809001913.GA10044@infradead.org> <20070809023217.GA3321@lazybastard.org> <20070809023906.GA18792@infradead.org> <20070809023920.GB3321@lazybastard.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070809023920.GB3321@lazybastard.org>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 09, 2007 at 04:39:20AM +0200, J??rn Engel wrote:
> Fair enough.  Does the file still make sense in include/linux/ then?

I don't think so.  Except for the one filesystem that's out there to repeat
past mistakes all recent ones keep their headers in their impleementation
directories.

