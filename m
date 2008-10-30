Return-Path: <linux-kernel-owner+w=401wt.eu-S1753329AbYJ3ERC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329AbYJ3ERC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 00:17:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750849AbYJ3EQx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 00:16:53 -0400
Received: from kroah.org ([198.145.64.141]:41110 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750768AbYJ3EQx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 00:16:53 -0400
Date: Wed, 29 Oct 2008 21:14:47 -0700
From: Greg KH <greg@kroah.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: driver core: get rid of bus_id ()
Message-ID: <20081030041447.GA18120@kroah.com>
References: <1225328796.5970.62.camel@nga.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225328796.5970.62.camel@nga.site>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2008 at 02:06:36AM +0100, Kay Sievers wrote:
> Hey Greg,
> this will be the final remove of bus_id and BUS_ID_SIZE, when
> everything else is converted.
> 
> Would be nice, if you can put that into your tree without pushing
> it to -next for now, but to catch newly added bus_id stuff in
> staging.

I'll add it to my local tree for this reason, and then move it to the
places -next pulls from when the other subsystems add their respective
patches.

thanks for doing this.

greg k-h
