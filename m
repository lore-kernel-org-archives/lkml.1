Return-Path: <linux-kernel-owner+w=401wt.eu-S1755330AbYBKLvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330AbYBKLvT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 06:51:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752106AbYBKLvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 06:51:09 -0500
Received: from smtp1-g19.free.fr ([212.27.42.27]:47837 "EHLO smtp1-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752060AbYBKLvI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 06:51:08 -0500
From: Duncan Sands <baldrick.bulk@free.fr>
To: Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [PATCH][USBATM]: convert heavy init dances to kthread API
Date: Mon, 11 Feb 2008 12:51:02 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20080118.763038)
Cc: linux-usb@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <47A9DD30.5040604@openvz.org> <200802102130.45196.baldrick.bulk@free.fr> <47B02FF3.80309@openvz.org>
In-Reply-To: <47B02FF3.80309@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802111251.03898.baldrick.bulk@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 February 2008 12:22:27 Pavel Emelyanov wrote:
> Duncan Sands wrote:
> > Hi Pavel,
> > 
> >> Oh, I see. You're right - this race is possible... I'll fix that up
> >> if this patch works.
> > 
> > it seems to work fine.  Thanks again for doing this!
> 
> Oh, thanks for testing. What should I do next to get this into
> mainline? Send it to Andrew with you in Cc, or you have you own
> tree for merging?

Please fix the race (see previous emails) and send it to Andew with Cc.

Thanks,

Duncan.
