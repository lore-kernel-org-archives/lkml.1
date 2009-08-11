Return-Path: <linux-kernel-owner+w=401wt.eu-S1752504AbZHKAC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504AbZHKAC1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 20:02:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752246AbZHKACY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 20:02:24 -0400
Received: from kroah.org ([198.145.64.141]:56600 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751105AbZHKACV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 20:02:21 -0400
Date: Mon, 10 Aug 2009 17:01:12 -0700
From: Greg KH <greg@kroah.com>
To: Lothar Wassmann <LW@KARO-electronics.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Michael Hennerich <michael.hennerich@analog.com>,
       Bryan Wu <cooloney@kernel.org>, Mike Frysinger <vapier@gentoo.org>,
       Lothar Wassmann <lothar@ipc1.ka-ro>
Subject: Re: [PATCH] Fix compiler warnings and remove debug messages
Message-ID: <20090811000112.GB13314@kroah.com>
References: <20090810193653.f228cf06.sfr@canb.auug.org.au>
 <1249921736508-git-send-email-LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249921736508-git-send-email-LW@KARO-electronics.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 10, 2009 at 06:28:56PM +0200, Lothar Wassmann wrote:
> This patch fixes the reported compiler warnings and removes excessive debug messages.
> Compile tested only!

I'd prefer the correct fixes for this driver.  Mike, any thoughts on
some fixes for this?

thanks,

greg k-h
