Return-Path: <linux-kernel-owner+w=401wt.eu-S1755127AbXJXDh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755127AbXJXDh1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 23:37:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753623AbXJXDhS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 23:37:18 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58516 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753584AbXJXDhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 23:37:17 -0400
Date: Tue, 23 Oct 2007 20:33:05 -0700
From: Greg KH <greg@kroah.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: const vs __{dev}initdata
Message-ID: <20071024033305.GA14383@kroah.com>
References: <200710232335.56766.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710232335.56766.bzolnier@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2007 at 11:35:56PM +0200, Bartlomiej Zolnierkiewicz wrote:
> 
> [ BTW Greg: this doesn't seem to be mentioned in LDD3. ]

_lots_ of things aren't mentioned in LDD3, and it's quite out of date
now, and we really don't have a plan to update it anytime soon :(

thanks,

greg k-h
