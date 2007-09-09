Return-Path: <linux-kernel-owner+w=401wt.eu-S1759282AbXIIUEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759282AbXIIUEe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 16:04:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754622AbXIIUEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 16:04:13 -0400
Received: from canuck.infradead.org ([209.217.80.40]:34441 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754287AbXIIUEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 16:04:12 -0400
Date: Sun, 9 Sep 2007 09:41:57 -0700
From: Greg KH <greg@kroah.com>
To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>, gregkh@suse.de,
       linux-usb-users@lists.sourceforge.net,
       linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH 2/2] ELAN U132 Host Controller Driver: convert
	scheduler_lock to mutex
Message-ID: <20070909164157.GB9199@kroah.com>
References: <20070906210922.GC3081@traven> <20070906211958.GE3081@traven> <20070907131054.GL3081@traven>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070907131054.GL3081@traven>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 07, 2007 at 03:10:54PM +0200, Matthias Kaehlcke wrote:
> A corrected version of the patch, the first one contained context
> removed by the first patch of this serie

This patch for some reason did not apply cleanly.

Care to redo it after the next -mm releae that has your first patch in
it (that looked fine.)

thanks,

greg k-h
