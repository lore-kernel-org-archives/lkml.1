Return-Path: <linux-kernel-owner+w=401wt.eu-S1761951AbYA1Qpy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761951AbYA1Qpy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 11:45:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760307AbYA1Qp3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 11:45:29 -0500
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:5526 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760159AbYA1QpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 11:45:24 -0500
Message-ID: <479E065E.5080105@panasas.com>
Date: Mon, 28 Jan 2008 18:44:14 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: mark USB drivers as being GPL only
References: <20080125180232.GA4613@kroah.com> <479DB203.2050809@panasas.com> <20080128161305.GB8790@kroah.com>
In-Reply-To: <20080128161305.GB8790@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Jan 2008 16:44:16.0404 (UTC) FILETIME=[053B9540:01C861CD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28 2008 at 18:13 +0200, Greg KH <greg@kroah.com> wrote:
> On Mon, Jan 28, 2008 at 12:44:19PM +0200, Boaz Harrosh wrote:
>> On Fri, Jan 25 2008 at 20:02 +0200, Greg KH <greg@kroah.com> wrote:
>>> FYI, this is a patch that will be sent out in the next round to Linus
>>> for inclusion in 2.6.25.
>>>
>>> If anyone has any objections about it, please let me know.
>> What about ndiswrapper and its windows binaries
>> are they covered through ndiswrapper by GPL?
>> (Unfortunately I use them, but less and less)
> 
> Sorry, but no, they are not going to work, due to the way that
> ndiswrapper is marked by the kernel module loader.
> 
I was afraid of that, yes.

> Again, you should be getting a kernel warning every time you try to use
> a USB function today.
> 
sigh, yes I do, but it's better then no networking.

> What USB drivers for wireless devices are not yet supported by Linux
> becides the Marvell-based ones (which some of us are actively working
> on...)?
> 
I'm not even sure, its an old vaio pII 512MZ. Still works like a charm
with Linux. I use a chokoloku usb dangle that I dismantled and assembled
inside the laptop case. I use the original windows drivers that came with
it.

Last time I checked with 2.6.20 it did not work, but I should now try
2.6.24 as I know things have advanced a lot. (It works and I'm just lazy)

> thanks,
> 
> greg k-h

Thank you, I do support what you are doing here. Just the ndiswrapper
is a special case. But I guess I, as a user, can always use it anyway,
right? But not the commercial distros. Don't stop the transition on my
account.

Boaz
