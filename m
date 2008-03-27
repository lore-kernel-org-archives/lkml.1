Return-Path: <linux-kernel-owner+w=401wt.eu-S1758311AbYC0Rxi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758311AbYC0Rxi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 13:53:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754376AbYC0Rxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 13:53:30 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:36897 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754165AbYC0Rx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 13:53:29 -0400
Date: Thu, 27 Mar 2008 10:52:24 -0700
From: Greg KH <greg@kroah.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Douglas Thompson <dougthompson@xmission.com>,
       Tim Small <tim@buttersideup.com>, bluesmoke-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: EDAC_I82443BXGX still depends on BROKEN
Message-ID: <20080327175224.GA15887@kroah.com>
References: <20080327173610.GB32200@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080327173610.GB32200@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 27, 2008 at 07:36:11PM +0200, Adrian Bunk wrote:
> It must become very good stuff when it takes Greg more than 8 months to 
> brew it...  ;-)

Yeah, it's driver core rework, the kobject stuff was the first step to
try to get there...

It's slow going unfortunatly other things more pressing keep popping up
ahead of it, it's getting there...

No objection to this patch at all:
	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

thanks,

greg k-h
