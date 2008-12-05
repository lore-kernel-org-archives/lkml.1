Return-Path: <linux-kernel-owner+w=401wt.eu-S1757431AbYLEP6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757431AbYLEP6e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 10:58:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754226AbYLEP6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 10:58:21 -0500
Received: from ns.suse.de ([195.135.220.2]:51450 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756617AbYLEP6S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 10:58:18 -0500
Date: Fri, 5 Dec 2008 07:53:56 -0800
From: Greg KH <gregkh@suse.de>
To: Christian Lamparter <chunkeey@web.de>
Cc: linux-wireless@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>,
       John W Linville <linville@tuxdriver.com>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] p54usb: fix usb_kill_urb hang with slub_debug=P
Message-ID: <20081205155356.GC28030@suse.de>
References: <200812051547.45790.chunkeey@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200812051547.45790.chunkeey@web.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 05, 2008 at 03:47:45PM +0100, Christian Lamparter wrote:
> This patch fixes a problem identified by Johannes Berg.

No, it only papers over the real problem here, let's work on a correct
patch please.

thanks,

greg k-h
