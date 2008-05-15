Return-Path: <linux-kernel-owner+w=401wt.eu-S1759655AbYEONqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759655AbYEONqQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 09:46:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753477AbYEONqA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 09:46:00 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:43585 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753203AbYEONp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 09:45:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=eBfX2Y2N3RDGKcIT+E7zmhjroPnZldial2Do2/+s5dtesBWT50qWvTpF1o1yT4JKxcTuS2OsnLpVjiZABdTR0K6tGS0+8dN9tFoh5t8BL3st74JqULWR7AVySV3b6YAapKZIJYJsA9+CCgRJD68qFq3HhzF8zkdLWFDO0q8NFYY=
Date: Thu, 15 May 2008 09:45:52 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Greg KH <greg@kroah.com>, jkosina@suse.cz, linux-input@vger.kernel.org,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: add appleir USB driver
Message-ID: <20080515094212.ZZRA012@mailhub.coreip.homeip.net>
References: <20080514221519.GA6575@kroah.com> <20080515132108.GA9327@dose.home.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080515132108.GA9327@dose.home.local>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tino,

On Thu, May 15, 2008 at 03:21:08PM +0200, Tino Keitel wrote:
> Hi,
>
> I'm pretty sure that this breaks the macmini LIRC driver again, see
> commit 3e1928e8793208802589aae851b6685671187242.
>

But with in-kernel driver can't LIRC feed of event device? Ane people
that dont use LIRC can also have access to the remote?

-- 
Dmitry
