Return-Path: <linux-kernel-owner+w=401wt.eu-S1754557AbXECGNj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754557AbXECGNj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 02:13:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754564AbXECGNj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 02:13:39 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:59816 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754557AbXECGNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 02:13:37 -0400
Date: Wed, 2 May 2007 22:30:47 -0700
From: Greg KH <greg@kroah.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       akpm@linux-foundation.org, gregkh@suse.de
Subject: Re: [PATCH 6/8] Kconfig: no userspace I/O on s390.
Message-ID: <20070503053047.GB7458@kroah.com>
References: <20070420113430.GG3738@skybase>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070420113430.GG3738@skybase>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2007 at 01:34:30PM +0200, Martin Schwidefsky wrote:
> From: Martin Schwidefsky <schwidefsky@de.ibm.com>
> 
> Hide the config menu for userspace I/O on s390.

Why?  Who says s390 can't have userspace I/O drivers someday?

thanks,

greg k-h
