Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381Ab0BWQB6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 11:01:58 -0500
Received: from newyear.aktivix.org ([209.234.249.206]:39774 "EHLO
	newyear.aktivix.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164Ab0BWQB5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 11:01:57 -0500
X-Greylist: delayed 1447 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Feb 2010 11:01:57 EST
From: "JimDog" <jimdog@aktivix.org>
To: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: =?UTF-8?B?R8OhYm9y?= Stefanik <netrolller.3d@gmail.com>,
       jimdog@northern-indymedia.org, gregkh@suse.de, jmm@debian.org,
       mithlesh@linsyssoft.com, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: RE:  [PATCH] Staging: wlan-ng:
 Fix 80 character limit warnings Fixed
 2  warnings identified by the checkpatch.pl
 tool which occured due to two lines  of
 code going over the 80 character limit.
 Fixed by wrapping the lines.  Signed-off-by: Jim Dog <jimdog@
Date: Tue, 23 Feb 2010 15:37:20 +0000
Message-ID: <WMMN06xmgZ5z.yLCyGsQc@newyear.aktivix.org>
X-Mailer: EPOC Email Version 2.10
MIME-Version: 1.0
Content-Language: i-default
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No probs, i'll sort it tomorrow and resubmit it

-original message-
Subject: Re: [PATCH] Staging: wlan-ng: Fix 80 character limit warnings Fixed 2  warnings identified by the checkpatch.pl tool which occured due to two lines  of code going over the 80 character limit. Fixed by wrapping the lines.  Signed-off-by: Jim Dog <jimdog@
From: Richard Kennedy <richard@rsk.demon.co.uk>
Date: 23/02/2010 2:35 pm

On Sun, 2010-02-21 at 16:06 +0100, Gábor Stefanik wrote:

> > +/*
> > +       {PRISM_USB_DEVICE(0x0ace, 0x1201, "ZyDAS ZD1201 Wireless USB Adapter")},
> > +*/
> 
> Why is this even included? We do have support for this in zd1201, and
> I'm pretty sure wlan-ng doesn't actually handle it.
> 
In that case, let's just remove it. It's only clutter and may cause
confusion.
JD do you want to update your patch to get rid of this?

regards
Richard 


