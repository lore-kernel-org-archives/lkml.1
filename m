Return-Path: <linux-kernel-owner+w=401wt.eu-S1760504AbYBEUg5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760504AbYBEUg5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 15:36:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759696AbYBEUgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 15:36:46 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:60674 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754695AbYBEUgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 15:36:45 -0500
Date: Tue, 5 Feb 2008 12:34:18 -0800
From: Greg KH <greg@kroah.com>
To: David Newall <davidn@davidnewall.com>
Cc: Marcel Holtmann <marcel@holtmann.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Christer Weinigel <christer@weinigel.se>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: mark USB drivers as being GPL only
Message-ID: <20080205203418.GA5819@kroah.com>
References: <20080125180232.GA4613@kroah.com> <20080202123710.42df1aa0@weinigel.se> <20080202191930.GA19826@kroah.com> <47A5D9CD.5070001@davidnewall.com> <84144f020802030743j1278ac64j2ee3e2cbc5c3fefc@mail.gmail.com> <47A5E67D.9040804@davidnewall.com> <1202058820.15090.60.camel@violet> <courier.47A84ADB.000047C1@hawking.rebel.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <courier.47A84ADB.000047C1@hawking.rebel.net.au>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 05, 2008 at 10:09:07PM +1030, David Newall wrote:
> Marcel Holtmann writes:
>> if a new drivers is originally written for Linux, then you are breaking
>> the GPL.
>
> Completely wrong.  However if the driver is distributed as built-in, then 
> it would need to be licensed under GPL.  This means that a driver can be 
> written and distributed as a module under any licence, proprietary or 
> otherwise, presumably with the restriction that it may NOT be built-in. 

Again, you are wrong, as per the recommendations of every lawyer I have
ever talked to (and unfortunatly, that's a lot...)

It's fine for you to feel differently, and you yourself can act however
you want to, but as you do not hold any copyright on any portions of the
Linux kernel code, please do not speak as if your statements hold any
weight.

In the end, it's up to the copyright holders to enforce the license.
And as I have stated in the past, a number of them have made public
statements as to what they think about this issue.  And it corresponds
exactly with what Marcel has stated above.

So if you wish to violate the copyright of others, you take the risk
that you might be caught and punished, something that you and your legal
council needs to take into account.

thanks,

greg k-h
