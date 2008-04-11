Return-Path: <linux-kernel-owner+w=401wt.eu-S1756685AbYDKVxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756685AbYDKVxb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 17:53:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756143AbYDKVxE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 17:53:04 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:45620 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754418AbYDKVxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 17:53:03 -0400
Date: Fri, 11 Apr 2008 14:36:35 -0700
From: Greg KH <greg@kroah.com>
To: "Hans J. Koch" <hjk@linutronix.de>
Cc: Uwe Kleine-K??nig <Uwe.Kleine-Koenig@digi.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] UIO: wrap all uio drivers in "if UIO" and "endif"
Message-ID: <20080411213635.GB32522@kroah.com>
References: <1207831023-8583-1-git-send-email-Uwe.Kleine-Koenig@digi.com> <1207831023-8583-2-git-send-email-Uwe.Kleine-Koenig@digi.com> <1207831023-8583-3-git-send-email-Uwe.Kleine-Koenig@digi.com> <1207831023-8583-4-git-send-email-Uwe.Kleine-Koenig@digi.com> <20080410194513.GD3193@local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080410194513.GD3193@local>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2008 at 09:45:14PM +0200, Hans J. Koch wrote:
> On Thu, Apr 10, 2008 at 02:37:02PM +0200, Uwe Kleine-K??nig wrote:
> > currently there is only one driver, but new entries don't need to depend
> > explicitly on UIO.
> 
> Agreed.
> 
> Signed-off-by: Hans J Koch <hjk@linutronix.de>

Already in the -mm tree...

thanks,

greg k-h
