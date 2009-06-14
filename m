Return-Path: <linux-kernel-owner+w=401wt.eu-S1760084AbZFNUBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760084AbZFNUBQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 16:01:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753498AbZFNUBB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 16:01:01 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46999 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753009AbZFNUBA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 16:01:00 -0400
Date: Sun, 14 Jun 2009 12:27:07 -0700
From: Greg KH <gregkh@suse.de>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: "Hans J. Koch" <hjk@linutronix.de>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, devicetree-discuss@ozlabs.org,
       Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [PATCH 2/2] uio: add an of_genirq driver
Message-ID: <20090614192707.GA11003@suse.de>
References: <1244765062-14144-1-git-send-email-w.sang@pengutronix.de> <1244765062-14144-3-git-send-email-w.sang@pengutronix.de> <20090614122136.GD3639@local> <20090614171406.GA1010@pengutronix.de> <20090614183357.GE3639@local> <20090614190533.GA7387@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090614190533.GA7387@pengutronix.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 14, 2009 at 09:05:33PM +0200, Wolfram Sang wrote:
> Well, I assume that issues regarding checkpatch do not have the highest
> priority (especially while the merge-window is open), which is understandable.

Hm, the "merge-window" for new stuff like these patches is pretty much
already closed, as you didn't send them _before_ the merge window opened
up.  You need to get them to us sooner, so we can test stuff out in the
-next tree for a while before we can merge them.

thanks,

greg k-h
