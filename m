Return-Path: <linux-kernel-owner+w=401wt.eu-S1755368AbXJ2EyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368AbXJ2EyR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 00:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751225AbXJ2EyF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 00:54:05 -0400
Received: from lixom.net ([66.141.50.11]:47775 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750848AbXJ2EyE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 00:54:04 -0400
Date: Mon, 29 Oct 2007 00:02:02 -0500
From: Olof Johansson <olof@lixom.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Ben Herrenschmidt <benh@kernel.crashing.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-fbdev-devel@lists.sourceforge.net
Subject: Re: [PATCH] Silence radeon_pm warning
Message-ID: <20071029050202.GA16159@lixom.net>
References: <20071029135911.ba1bfee2.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071029135911.ba1bfee2.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2007 at 01:59:11PM +1100, Stephen Rothwell wrote:
> drivers/video/aty/radeon_pm.c:30: warning: 'radeon_reinitialize_M10' declared 'static' but never defined
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>

I posted this one a few days ago, without adding a new ifdef (just moving the
declaration down into the already existing ifdef below it):

http://marc.info/?l=linux-kernel&m=119311699109698&w=2


-Olof

