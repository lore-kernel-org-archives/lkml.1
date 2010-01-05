Return-Path: <linux-kernel-owner+w=401wt.eu-S1755377Ab0AEWsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755377Ab0AEWsV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 17:48:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754921Ab0AEWsU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 17:48:20 -0500
Received: from mail-yw0-f176.google.com ([209.85.211.176]:60008 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770Ab0AEWsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 17:48:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=YRhSvTBPlBr132jdN/U6IwvmdQb19lfV03Auugv/oe3to4GJh+BSienCdRZ7jenN6u
         wfSFunV3m3Ln7jy0lxHybf+QHDAtP75skyIjyCvdXCU6t6cRS0YMMv95Yzo+Pwj1VKR4
         C2ihaky9mM45CzDtWKed7lqc3tgWnUc8Q3YAE=
Date: Tue, 5 Jan 2010 14:40:52 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: William Manson <WManson@synaptics.com>
Cc: Christopher Heiny <Cheiny@synaptics.com>,
       Allie Xiong <axiong@synaptics.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [PATCH 1/1] input/touchscreen: Synaptics Touchscreen Driver
Message-ID: <20100105224051.GA7869@core.coreip.homeip.net>
References: <20100103223025.GA4496@core.coreip.homeip.net>
 <7B4B50AC280A5E45A42CD2D364A3CE2F2733F75A3E@USW-EX2K7-1.synaptics-inc.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7B4B50AC280A5E45A42CD2D364A3CE2F2733F75A3E@USW-EX2K7-1.synaptics-inc.local>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 05, 2010 at 01:57:37PM -0800, William Manson wrote:
> Hi Dmitry -
> 
> Yes - we are planning on extending support for our new touchpads. As
> far as I know there is a Linux PS/2 driver in the works but I don't
> work with that group so I don't know anything about timeframes.

Is there a way to get in touch with that group? As you may know we have
a pretty stable and reliable version of a driver for your older PS/2
products (thanks to Synaptics releasing very detailed interfacing guide)
which is integrated in both kernel and Xorg, and which is used by most
distributions. Users also expect "synaptics" to just work with their
touchpads. I would rather see patches extending the exsting driver
instead of completely new piece of software.

> I also
> don't know if it will be made open source or as a proprietary binary -
> or both. But we are definitely planning on supporting our PS/2
> touchpads on Linux.
> 
> I will check into the Interfacing Guide and get back to you. The
> latest is on our web site
> (http://www.synaptics.com/developers/manuals) but it doesn't have info
> about multitouch in it. If there is a newer one I'll let you know.
>

Thank you, much appreciated.

-- 
Dmitry
