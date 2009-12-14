Return-Path: <linux-kernel-owner+w=401wt.eu-S1757650AbZLNQFM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757650AbZLNQFM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 11:05:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757626AbZLNQFK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 11:05:10 -0500
Received: from kroah.org ([198.145.64.141]:54584 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757603AbZLNQFJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 11:05:09 -0500
Date: Mon, 14 Dec 2009 08:04:16 -0800
From: Greg KH <greg@kroah.com>
To: Frank Schaefer <schaefer.frank@gmx.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Bug 14594: fix for 2.6.31.8 ?
Message-ID: <20091214160416.GA30055@kroah.com>
References: <4B265FEC.6060503@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B265FEC.6060503@gmx.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 14, 2009 at 04:55:24PM +0100, Frank Schaefer wrote:
> Bug 14594 has been fixed with commit
> e29d4363174949a7a4e46f670993d7ff43342c1c for 2.6.32 a month ago, but
> 2.6.28 - 2.6.31.7 are still affected.
> Any plans to apply this at least for 2.6.31.8, too ?

It was never sent to the stable@kernel.org alias so how would I know to
apply this?

I'll queue it up for the next round.

thanks,

greg k-h
