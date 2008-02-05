Return-Path: <linux-kernel-owner+w=401wt.eu-S1756638AbYBEHtx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638AbYBEHtx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 02:49:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753053AbYBEHtn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 02:49:43 -0500
Received: from otello.alma.unibo.it ([137.204.24.163]:51611 "EHLO
	otello.alma.unibo.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109AbYBEHtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 02:49:42 -0500
Message-ID: <47A81514.3040101@otello.alma.unibo.it>
Date: Tue, 05 Feb 2008 08:49:40 +0100
From: Diego Zuccato <diego@otello.alma.unibo.it>
User-Agent: Thunderbird 2.0.0.9 (X11/20080114)
MIME-Version: 1.0
To: Christer Weinigel <christer@weinigel.se>
Cc: David Newall <davidn@davidnewall.com>, Greg KH <greg@kroah.com>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: mark USB drivers as being GPL only
References: <20080125180232.GA4613@kroah.com> <20080202123710.42df1aa0@weinigel.se> <20080202191930.GA19826@kroah.com> <47A5D895.20300@davidnewall.com> <47A6E742.80408@otello.alma.unibo.it> <47A764ED.8030605@weinigel.se>
In-Reply-To: <47A764ED.8030605@weinigel.se>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christer Weinigel ha scritto:

> It isn't that easy.  The "Tamper-Proof Torx" screws on a vacuum cleaner 
> or a toaster won't stop anybody from opening up the thing, I mean every 
> little hardware store stocks those Torx bits.  But by using a slightly 
> odd screw, the company can say "look, we'we done all we can to stop 
> them, but the user bypassed our security device, and it's not our 
> fault".
ROFL! Well, since a lot of screwdriver types are easily available, I 
don't think a judge could agree with 'em...

> Apparently Intel and Atheros are trying to protect themselves 
> in a similar way, they Open Source everything except for the regulatory 
> daemon (Intel) or HAL object file (Atheros).  Why?  Because they belive 
> that if they give away the sources to those parts they do the software 
> equivalent of putting a normal Phillips screw in a home appliance. 
> (Personally I think what they are doing is ridiculous, but apparently 
> those companies' lawyers dont' agree).
Well, then why close the driver? Simply place the check in the firmware. 
Much harder to find, since it have to run on proprietary HW. The OS 
driver instead runs on standard (and usualli well-known) HW.
Keeping the screws similitude, closing the driver is more like using a 
Torx, while placing checks in the FW is more like using a lock-only 
screw (already seen some)...

[...]
> so hiding the source really doesn't help.
Well, we all agree on this... Now we just have to make THEM agree, too...


BYtE,
  Diego.
