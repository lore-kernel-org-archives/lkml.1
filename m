Return-Path: <linux-kernel-owner+w=401wt.eu-S1759446AbZE1DWM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759446AbZE1DWM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 23:22:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754377AbZE1DV6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 23:21:58 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:56028 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754331AbZE1DV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 23:21:57 -0400
MIME-Version: 1.0
In-Reply-To: <4A1DD3A0.3010501@freescale.com>
References: <1243408083.13460.14.camel@debian-nb> <fa686aa40905270727m31250984tf12249fc87179ce9@mail.gmail.com> 
	<ed82fe3e0905270739k38018c87ka11f62c5977e45fb@mail.gmail.com> 
	<20090527150527.GK6805@pengutronix.de> <fa686aa40905270839m375bbdacqb1acb1be0a2d2da0@mail.gmail.com> 
	<20090527162000.GM6805@pengutronix.de> <fa686aa40905271335o1165419hda2334bef42aa3f@mail.gmail.com> 
	<20090527234801.GP6805@pengutronix.de> <4A1DD3A0.3010501@freescale.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 27 May 2009 21:21:39 -0600
Message-ID: <fa686aa40905272021l13aa63ddh9b7409abb181f707@mail.gmail.com>
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
To: Scott Wood <scottwood@freescale.com>
Cc: Robert Schwebel <r.schwebel@pengutronix.de>,
       devicetree-discuss <devicetree-discuss@ozlabs.org>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       Janboe Ye <yuan-bo.ye@motorola.com>, Timur Tabi <timur@freescale.com>,
       rmk@arm.linux.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27, 2009 at 5:58 PM, Scott Wood <scottwood@freescale.com> wrote:
> Robert Schwebel wrote:
>>
>> The oftree by design wants to be a complete hardware description. As you
>> mention above, there are cases where you *nevertheless* need ad-hoc
>> information about things *not* encoded into the device tree.
>>
>> This renders the whole concept ad absurdum. You need a machine number
>> again - and if you need that: why not stay with the ARM model, define
>> everything with platform data and avoid the whole thing?
>
> Because it's better to have a little platform specific code than a lot of
> it?

Yes, exactly.

g.


-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
