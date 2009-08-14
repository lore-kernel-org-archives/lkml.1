Return-Path: <linux-kernel-owner+w=401wt.eu-S932176AbZHNGXD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932176AbZHNGXD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 02:23:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755788AbZHNGXC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 02:23:02 -0400
Received: from lider.pardus.org.tr ([193.140.100.216]:40517 "EHLO
	lider.pardus.org.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754691AbZHNGXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 02:23:01 -0400
Message-ID: <4A850395.4050204@pardus.org.tr>
Date: Fri, 14 Aug 2009 09:26:29 +0300
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
User-Agent: Thunderbird 2.0.0.22 (X11/20071115)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [patch 00/74] 2.6.30.5-stable review
References: <20090813195705.GA22393@kroah.com>
In-Reply-To: <20090813195705.GA22393@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote On 13-08-2009 22:57:
> This is the start of the stable review cycle for the 2.6.30.5 release.
> There are 74 patches in this series, all will be posted as a response to
> this one.  If anyone has any issues with these being applied, please let
> us know.  If anyone is a maintainer of the proper subsystem, and wants
> to add a Signed-off-by: line to the patch, please respond with it.
>
> These patches are sent out with a number of different people on the Cc:
> line.  If you wish to be a reviewer, please email stable@kernel.org to
> add your name to the list.  If you want to be off the reviewer list,
> also email us.
>
> Responses should be made by Saturday, August 15, 2009 19:00:00 UTC.
> Anything received after that time might be too late.
>   

Hi,

According to the stable_kernel_rules document, new device IDs and quirks
should also be accepted. I wonder if it's possible to cherry-pick new
device additions to usb-serial modem drivers (HSDPA stuff) for further
releases?

And also there was this one that may be included in .5:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=0083fc2c50e6c5127c2802ad323adf8143ab7856

Regards,
Ozan Caglayan
