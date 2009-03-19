Return-Path: <linux-kernel-owner+w=401wt.eu-S1760992AbZCSUPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760992AbZCSUPv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 16:15:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759589AbZCSUPV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 16:15:21 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:57422 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760469AbZCSUPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 16:15:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=odGnfpFTVgocJkibmvP0TlUTXIRkJNlCTVKTESFsqY15gILH4fKiAWiseJOYZ0QML9
         yxKeaPtAG54Xwb3jikdqbdigtruki2jUT12seZkSKvASi2Fv22wk9e2m/mCoXMfykPBb
         3Bs2c47EIYuw1MgDvVhor2aWDbinFmkJTodOg=
Message-ID: <49C2A7D2.3020306@gmail.com>
Date: Thu, 19 Mar 2009 13:15:14 -0700
From: Corbin Simpson <mostawesomedude@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Richard Purdie <rpurdie@linux.intel.com>
CC: Sindhudweep Sarkar <sindhudweep.sarkar@gmail.com>,
       David Airlie <airlied@linux.ie>, Greg KH <greg@kroah.com>,
       Thomas Hellstrom <thellstrom@vmware.com>,
       dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [patch 0/5] Intel Poulsbo/Morrestown DRM driver and DRM core
 	changes
References: <20090319040809.GA29249@kroah.com>	<6c046ab30903190903r298a0334n939e64403b8aeda6@mail.gmail.com> <1237482776.5359.89.camel@dax.rpnet.com>
In-Reply-To: <1237482776.5359.89.camel@dax.rpnet.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Purdie wrote:
> On Thu, 2009-03-19 at 12:03 -0400, Sindhudweep Sarkar wrote:
>> This might be the opinion of a completely non educated end user but it
>> seems that an intel specific drm and other bits (xorg, mesa) would be
>> somewhat of a maintenance waste.
>>
>> TI-OMAP 3xxx and a couple of other arm processors use similar SGX-5xx
>> graphics cores. IIRC arm is often little endian so perhaps a unified
>> driver would be easier in the long term.
> 
> Long term a unified driver would be very nice to have and nobody
> disagrees with that. Things don't happen overnight and you have to take
> smaller steps to get there. This proposal is one step on a road that may
> lead to a driver for the TI part too. It will need someone in the ARM
> community to step up and write the ARM specific bits.

Nokia's written and open-sourced some related code for DRM.

My university is paying me to work on an ARM-based SoC handheld with an
SGX core, and I might be more into this later. (Y'know, once the device
is actually out the door.)

~ C.
