Return-Path: <linux-kernel-owner+w=401wt.eu-S1754593AbZKTRnr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593AbZKTRnr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 12:43:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753491AbZKTRnr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 12:43:47 -0500
Received: from kroah.org ([198.145.64.141]:40251 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751652AbZKTRnq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 12:43:46 -0500
Date: Fri, 20 Nov 2009 09:35:17 -0800
From: Greg KH <greg@kroah.com>
To: Alan Cox <alan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/11] sdio_uart: Switch to the open/close helpers
Message-ID: <20091120173517.GA14888@kroah.com>
References: <20091118141802.3582.47363.stgit@localhost.localdomain>
 <20091118141952.3582.66265.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091118141952.3582.66265.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 18, 2009 at 02:19:57PM +0000, Alan Cox wrote:
> Gets us proper tty semantics, removes some code and fixes up a few corner
> case races (hangup during open etc)
> 
> Signed-off-by: Alan Cox <alan@linux.intel.com>

Something is wierd here, this patch doesn't apply.  And if I do it by
hand and fix up the errors, then patch 7 doesn't apply.

Wierd.

How about I take the first 5 and then you resync and send me the next 6?

thanks,

greg k-h
