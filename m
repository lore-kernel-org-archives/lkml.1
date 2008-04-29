Return-Path: <linux-kernel-owner+w=401wt.eu-S1754851AbYD2RLf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851AbYD2RLf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 13:11:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751749AbYD2RLO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 13:11:14 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:39218 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563AbYD2RLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 13:11:12 -0400
Date: Tue, 29 Apr 2008 09:50:20 -0700
From: Greg KH <greg@kroah.com>
To: "Gerd v. Egidy" <gerd.von.egidy@intra2net.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [stable] [PATCH] fix oops on rmmod capidrv
Message-ID: <20080429165020.GB29911@kroah.com>
References: <200801241750.14669.gerd.von.egidy@intra2net.com> <200804291527.29611.gerd.von.egidy@intra2net.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804291527.29611.gerd.von.egidy@intra2net.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2008 at 03:27:29PM +0200, Gerd v. Egidy wrote:
> Hi,
> 
> my patch below was added to 2.6.23.15 and linus tree that became 2.6.25, but 
> was too late for 2.6.24. So if you consider another stable release for 2.6.24 
> you might want to add that patch too.

Now added to the queue.

thanks,

greg k-h
