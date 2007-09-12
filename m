Return-Path: <linux-kernel-owner+w=401wt.eu-S970925AbXILSw3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970925AbXILSw3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 14:52:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752239AbXILSwW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 14:52:22 -0400
Received: from waste.org ([66.93.16.53]:43252 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752235AbXILSwV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 14:52:21 -0400
Date: Wed, 12 Sep 2007 13:50:49 -0500
From: Matt Mackall <mpm@selenic.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, kgdb-bugreport@lists.sourceforge.net,
       amitkale@linsyssoft.com,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       jason.wessel@windriver.com, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -mm v2] 2.6.23-rc4-mm1: kgdboe link errors
Message-ID: <20070912185049.GX4219@waste.org>
References: <46E7B1EA.2040009@gmail.com> <20070912101537.129d10c7.randy.dunlap@oracle.com> <20070912181512.GQ4219@waste.org> <20070912112252.7658b7db.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070912112252.7658b7db.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2007 at 11:22:52AM -0700, Randy Dunlap wrote:
> On Wed, 12 Sep 2007 13:15:12 -0500 Matt Mackall wrote:
> 
> > NETCONSOLE shouldn't be necessary. Otherwise this looks ok to my
> > kconfig-addled brain.
> 
> Correct.  Patch corrected.  Thanks.

Looks good to me, but I'll leave the actual ack to the KGDB guys.

-- 
Mathematics is the supreme nostalgia of our time.
