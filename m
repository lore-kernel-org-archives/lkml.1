Return-Path: <linux-kernel-owner+w=401wt.eu-S1760588AbZCMRCx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760588AbZCMRCx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 13:02:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759674AbZCMRBB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 13:01:01 -0400
Received: from kotten8a.marieberg.ac ([213.238.238.22]:40058 "HELO
	iluvatar.nyren.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759610AbZCMRBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 13:01:00 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Mar 2009 13:00:59 EDT
Date: Fri, 13 Mar 2009 17:54:09 +0100 (CET)
From: Ralf Nyren <ralf@nyren.net>
X-X-Sender: plumbum@fujje.iml.umu.se
To: Rory Filer <rfiler@SierraWireless.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Kevin Lloyd <klloyd@SierraWireless.com>
Subject: Re: your mail
In-Reply-To: <8F90F944E50427428C60E12A34A309D21C401BA619@carmd-exchmb01.sierrawireless.local>
Message-ID: <alpine.DEB.1.10.0903131751120.8432@fujje.iml.umu.se>
References: <8F90F944E50427428C60E12A34A309D21C401BA619@carmd-exchmb01.sierrawireless.local>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rory,

Sounds great, send the driver and I'll give it a try at once. I'll report back
to you with the results.

Many thanks, Ralf

On Fri, 13 Mar 2009, Rory Filer wrote:

> Hi Ralf
>
>
>
> Kevin passed your email on to my attention and I think we can help you with this problem. We've been doing a lot of work on our drivers lately and I've got a freshly-ready version of sierra.c just for 2.6.28. We've done a lot of testing here and it seems pretty robust; perhaps you'd be willing to give it a try?
>
>
>
> Since I'm not sure about the etiquette for posting to this list, so I will attach the driver in a separate email to you.
>
>
>
> Regards
>
>
>
> Rory Filer
>
>
>
>
>
> -----Original Message-----
>
> From: Ralf Nyren [mailto:ralf@nyren.net]
>
> Sent: Friday, March 13, 2009 8:01 AM
>
> To: linux-kernel@vger.kernel.org
>
> Cc: Kevin Lloyd
>
> Subject: Sierra Wireless (MC8780) HSDPA speed issue
>
>
>
> Hi,
>
>
>
> I have a Sierra Wireless MC8780 UMTS card in a Fujitsu S6410 laptop running kernel 2.6.28.7. In kernel sierra driver v1.3.2.
>
>
>
> The card works but speed seems limited to approx 1.0 Mbit/s download using the linux driver.  Testing the card in Windows XP yields download speeds close to 5.0 Mbit/s.
>
>
>
> I recently updated the firmware of the card to support HSDPA/HSUPA. The update gave the desired result in Windows but not in Linux. The speed improved in Linux but didn't increase above 1 Mbit/s.
>
>
>
> Is there any known driver limitations or is this a configuration issue?
>
>
>
> Please let me know if you need any additional information.
>
>
>
> Best regards, Ralf
>
>
