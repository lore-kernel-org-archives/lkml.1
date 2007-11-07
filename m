Return-Path: <linux-kernel-owner+w=401wt.eu-S1759938AbXKGXYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759938AbXKGXYc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 18:24:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753475AbXKGXYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 18:24:24 -0500
Received: from rtr.ca ([76.10.145.34]:4456 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752336AbXKGXYX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 18:24:23 -0500
Message-ID: <47324926.4070809@rtr.ca>
Date: Wed, 07 Nov 2007 18:24:22 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
Cc: Mark Lord <liml@rtr.ca>, Denys Fedoryshchenko <denys@visp.net.lb>,
       James Andrewartha <jamesa@daa.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, alan@lxorguk.ukuu.org.uk, htejun@gmail.com
Subject: Re: SC1200 failure in 2.6.23 and 2.6.24-rc1-git10
References: <20071101213013.M54162@visp.net.lb> <20071106221521.4f64a066.akpm@linux-foundation.org> <20071107132630.M65286@visp.net.lb> <4731D85E.70201@daa.com.au> <20071107160426.M31617@visp.net.lb> <47320E37.8010106@rtr.ca> <20071107232045.GA26706@havoc.gtf.org>
In-Reply-To: <20071107232045.GA26706@havoc.gtf.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> On Wed, Nov 07, 2007 at 02:12:55PM -0500, Mark Lord wrote:
>> That cannot be correct (??).  Is this with hdparm-7.7 (latest sourceforge) 
>> ??
>> Can you show us the "hdparm --Istdout" output as well, please.
> 
> If this is applicable...  FWIW hdparm was only recently (in past <72
> hours) updated from 6.9 to 7.7 in Fedora...
> 
> 	Jeff

Woo-hoo!
