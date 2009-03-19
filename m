Return-Path: <linux-kernel-owner+w=401wt.eu-S1756175AbZCSKiq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175AbZCSKiq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 06:38:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754107AbZCSKig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 06:38:36 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56578 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754091AbZCSKif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 06:38:35 -0400
Date: Thu, 19 Mar 2009 10:39:03 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Thomas =?ISO-8859-14?B?SGVsbHN0cvZt?= <thomas@shipmail.org>
Cc: Dave Airlie <airlied@gmail.com>, Greg KH <greg@kroah.com>,
       David Airlie <airlied@linux.ie>,
       Thomas Hellstrom <thellstrom@vmware.com>,
       dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Richard Purdie <rpurdie@linux.intel.com>
Subject: Re: [patch 0/5] Intel Poulsbo/Morrestown DRM driver and DRM core 
 changes
Message-ID: <20090319103903.43dd1ab3@lxorguk.ukuu.org.uk>
In-Reply-To: <49C21B0B.4060809@shipmail.org>
References: <20090319040809.GA29249@kroah.com>
	<21d7e9970903182348v57a78188ocefe138d353ee197@mail.gmail.com>
	<49C21B0B.4060809@shipmail.org>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The non-existence of an open-source 3D implementation doesn't really 
> alter that situation.

I think it does to an extent
> 
> However, if there's a policy issue about adding Linux kernel support for 
> closed-source user-space drivers, I think it helps to be explicit about 
> that.

Actually its a lawyer question not just policy. If the two parts being put
together are tightly dependant on each other and in fact form a single
work which it seems could reasonably be the case in this situation then
if one half is GPL the other must also be so.

There is also policy on this, I refer you back to the Intel wireless and
binary management daemon discussions. I likewise refer you to some of the
input device discussions related to USB HID and devices where vendors
wanted us to exclude their device in favour of proprietary libusb drivers.

Alan
