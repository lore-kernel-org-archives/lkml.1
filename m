Return-Path: <linux-kernel-owner+w=401wt.eu-S1765868AbXHOOt3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765868AbXHOOt3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 10:49:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761034AbXHOOtS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 10:49:18 -0400
Received: from twin.jikos.cz ([213.151.79.26]:36022 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761819AbXHOOtR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 10:49:17 -0400
Date: Wed, 15 Aug 2007 16:49:02 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Florin Iucha <florin@iucha.net>
cc: linux-usb-devel@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: [linux-usb-devel] USB-related oops in sysfs with linux
 v2.6.23-rc3-50-g28e8351
In-Reply-To: <20070815133147.GA7124@iucha.net>
Message-ID: <Pine.LNX.4.64.0708151647540.2460@twin.jikos.cz>
References: <20070815133147.GA7124@iucha.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Aug 2007, Florin Iucha wrote:

> Today my USB keyboard stopped working in the middle of composing and
> e-mail.  I unplugged it and plugged it back, with no success.  I
> logged in remotely and found this lovely message:

The error message seems unrelated to your keyboard becoming dead.

> I am testing each rcX kernel, and I did not see this problem so far. 
> Smells like a new regression.

Is that reproducible, or did it happen just once? Any error message 
present in log prior to that sysfs dump please?

Thanks,

-- 
Jiri Kosina
