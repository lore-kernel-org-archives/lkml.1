Return-Path: <linux-kernel-owner+w=401wt.eu-S1755045AbYACH5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755045AbYACH5U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 02:57:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753066AbYACH5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 02:57:12 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:60183 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbYACH5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 02:57:11 -0500
X-IronPort-AV: E=Sophos;i="4.24,238,1196658000"; 
   d="scan'208";a="46111425"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "David Brownell" <david-b@pacbell.net>
Subject: Re: [linux-usb-devel] [PATCH] : Allow embedded developers USB options normally reserved for OTG
Date: Thu, 3 Jan 2008 02:58:09 -0500
User-Agent: KMail/1.9.5
Cc: linux-usb-devel@lists.sourceforge.net, gregkh@suse.de,
       linux-kernel@vger.kernel.org
References: <200801020948.51310.rgetz@blackfin.uclinux.org> <200801022203.04991.rgetz@blackfin.uclinux.org> <200801021943.38716.david-b@pacbell.net>
In-Reply-To: <200801021943.38716.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801030258.09185.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 03 Jan 2008 07:57:10.0124 (UTC) FILETIME=[3E2C7AC0:01C84DDE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2 Jan 2008 22:43, David Brownell pondered:
> This patch might be improved slightly -- in ways that, as I
> understand things, could save some RAM on Blackfin! -- by
> having the BLACKLIST_HUB option get rid of the transaction
> translator support (changing C code not just Kconfig).
> It's pretty minimal, but won't be used...
>
> Also, as you point out, it's no longer OTG specific, so
> renaming the option would improve clarity.   Maybe to
> something along the lines of USB_HOST_NO_EXTERNAL_HUBS.
> No big deal, at least now.

Are these two things something that you want me to have a stab at, or since 
you are more familiar with it - you want to do it.

Thanks
-Robin
