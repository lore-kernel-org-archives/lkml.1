Return-Path: <linux-kernel-owner+w=401wt.eu-S1756211AbYBGMxN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211AbYBGMxN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 07:53:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760868AbYBGMwn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 07:52:43 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:34774 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756942AbYBGMwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 07:52:42 -0500
Message-ID: <47AAFF17.9070106@davidnewall.com>
Date: Thu, 07 Feb 2008 23:22:39 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Christer Weinigel <christer@weinigel.se>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: mark USB drivers as being GPL only
References: <20080125180232.GA4613@kroah.com> <20080202123710.42df1aa0@weinigel.se> <20080202191930.GA19826@kroah.com> <20080203124849.0226560f@weinigel.se> <84144f020802030635h3a9c4304n943d117e936f1c2d@mail.gmail.com> <47A5F418.6030104@weinigel.se> <20080203231530.GB15692@kroah.com> <courier.47A8EDDC.0000785F@hawking.rebel.net.au> <20080205232916.GA9040@kroah.com>
In-Reply-To: <20080205232916.GA9040@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Wed, Feb 06, 2008 at 09:44:36AM +1030, David Newall wrote:
>   
>> A kernel module is akin to a process.  It uses services of the kernel 
>> without being part of the kernel.
>>     
>
> No Linux does not work like this at all.
> ...
> Also see the various issues surrounding "loadable modules" and Samba,
> and how they have successfully enforced the "linking" and other type
> issues that are being discussed here (shims, "GPL condoms", etc.) with
> regards to the GPLv2 and derivative works.

If you know of something relevant, give pointers.
