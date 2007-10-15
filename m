Return-Path: <linux-kernel-owner+w=401wt.eu-S1762224AbXJOKPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762224AbXJOKPa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 06:15:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757944AbXJOKPP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 06:15:15 -0400
Received: from lucidpixels.com ([75.144.35.66]:57730 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757848AbXJOKPK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 06:15:10 -0400
Date: Mon, 15 Oct 2007 06:15:09 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: Rudolf Marek <r.marek@assembler.cz>
cc: "Mark M. Hoffman" <mhoffman@lightlink.com>, apiszcz@solarrain.com,
       lm-sensors <lm-sensors@lm-sensors.org>, linux-kernel@vger.kernel.org,
       Hans de Goede <j.w.r.degoede@hhs.nl>
Subject: Re: [lm-sensors] 2.6.23.1 x86 hardware monitoring bug?
In-Reply-To: <47132EE2.1050208@assembler.cz>
Message-ID: <Pine.LNX.4.64.0710150614390.14804@p34.internal.lan>
References: <Pine.LNX.4.64.0710141526590.3935@p34.internal.lan>
 <20071015025331.GA3676@jupiter.solarsys.private>
 <Pine.LNX.4.64.0710150406220.9867@p34.internal.lan> <47132EE2.1050208@assembler.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 15 Oct 2007, Rudolf Marek wrote:

> Hi,
>
> Most likely you have distro and custom libsensors installed on the system. 
> (and different PATH for root)
>
> Please check how many of libsensors libraries is installed.
>
> Thanks,
>
> Rudolf
>

I only had one, in /app (lm-sensors-2.10.2) -- which has been removed, 
thanks..

Justin.
