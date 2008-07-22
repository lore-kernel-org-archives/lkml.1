Return-Path: <linux-kernel-owner+w=401wt.eu-S1753681AbYGVPdc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753681AbYGVPdc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 11:33:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750794AbYGVPdY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 11:33:24 -0400
Received: from cantor.suse.de ([195.135.220.2]:33283 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750784AbYGVPdX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 11:33:23 -0400
Date: Tue, 22 Jul 2008 08:27:31 -0700
From: Greg KH <gregkh@suse.de>
To: Benny Halevy <bhalevy@panasas.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: [GIT PATCH] USB patches for 2.6.26
Message-ID: <20080722152731.GA31589@suse.de>
References: <20080721223038.GA2051@suse.de> <4885A05B.1090401@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4885A05B.1090401@panasas.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2008 at 11:54:51AM +0300, Benny Halevy wrote:
> You mean for 2.6.27, right?

No, they are to be applied to Linus's current tree, which right now is
still 2.6.26 (2.6.26-git8 or so to be exact).

They will show up in 2.6.27 though :)

thanks,

greg k-h
