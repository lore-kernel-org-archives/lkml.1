Return-Path: <linux-kernel-owner+w=401wt.eu-S1760010AbXEMU7g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760010AbXEMU7g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 16:59:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755329AbXEMU73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 16:59:29 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:36784 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754857AbXEMU73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 16:59:29 -0400
Date: Sun, 13 May 2007 21:59:24 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Greg KH <greg@kroah.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, kristen.c.accardi@intel.com
Subject: Re: pci hotplug patches
Message-ID: <20070513205924.GA13985@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	kristen.c.accardi@intel.com
References: <20070430162007.ad46e153.akpm@linux-foundation.org> <20070501084841.GC14364@infradead.org> <20070502035745.GB8877@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070502035745.GB8877@kroah.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 01, 2007 at 08:57:45PM -0700, Greg KH wrote:
> Hm, I'm no longer the PCI Hotplug maintainer, so that's why I haven't
> added them to my tree.  It would probably be best for everyone involved
> to send them to her instead :)

FYI: MAINTAINERS still lists you as the maintainer of the cpqphp driver.

