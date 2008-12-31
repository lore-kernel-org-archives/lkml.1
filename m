Return-Path: <linux-kernel-owner+w=401wt.eu-S1756637AbYLaRiV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756637AbYLaRiV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 12:38:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755921AbYLaRiL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 12:38:11 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:41955 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755384AbYLaRiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 12:38:10 -0500
X-IronPort-AV: E=Sophos;i="4.36,309,1228107600"; 
   d="scan'208";a="64650339"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Jaya Kumar" <jayakumar.lkml@gmail.com>
Subject: Re: [RFC 2.6.27 1/1] gpiolib: add support for batch set of pins
Date: Wed, 31 Dec 2008 12:38:13 -0500
User-Agent: KMail/1.9.5
Cc: "David Brownell" <david-b@pacbell.net>,
       "Eric Miao" <eric.y.miao@gmail.com>, "Sam Ravnborg" <sam@ravnborg.org>,
       "Eric Miao" <eric.miao@marvell.com>,
       "Haavard Skinnemoen" <hskinnemoen@atmel.com>,
       "Philipp Zabel" <philipp.zabel@gmail.com>,
       "Russell King" <rmk@arm.linux.org.uk>,
       "Ben Gardner" <bgardner@wabtec.com>, "Greg KH" <greg@kroah.com>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org
References: <12276535632759-git-send-email-jayakumar.lkml@gmail.com> <200812302355.45193.rgetz@blackfin.uclinux.org> <45a44e480812302058k365eddcfxf902095657b78534@mail.gmail.com>
In-Reply-To: <45a44e480812302058k365eddcfxf902095657b78534@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812311238.13810.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 31 Dec 2008 17:38:05.0966 (UTC) FILETIME=[89D322E0:01C96B6E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 30 Dec 2008 23:58, Jaya Kumar pondered:
> On Tue, Dec 30, 2008 at 11:55 PM, Robin Getz <rgetz@blackfin.uclinux.org> wrote:
> > Yeah, I hadn't thought about spanning more than one gpio_chip. That's a good
> > point.
> 
> The currently posted code already supports spanning more than one gpio_chip.
> 

But doesn't do all the other things that David suggested/requested.
