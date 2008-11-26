Return-Path: <linux-kernel-owner+w=401wt.eu-S1755466AbYKZVP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466AbYKZVP7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 16:15:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755795AbYKZVPi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 16:15:38 -0500
Received: from ceres.twam.info ([84.16.224.131]:49442 "EHLO smtp.twam.info"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755763AbYKZVPh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 16:15:37 -0500
X-Greylist: delayed 564 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Nov 2008 16:15:37 EST
Message-ID: <4b04f768614db905a9e9e8f7bfb88393.squirrel@twam.homeip.net>
In-Reply-To: <alpine.LNX.1.10.0811261632340.19853@jikos.suse.cz>
References: <1227710025-23592-1-git-send-email-Scholz@fias.uni-frankfurt.de>
    <1227710025-23592-2-git-send-email-Scholz@fias.uni-frankfurt.de>
    <alpine.LNX.1.10.0811261553010.19853@jikos.suse.cz>
    <87ej0ywm79.fsf@scholz.fias.uni-frankfurt.de>
    <alpine.LNX.1.10.0811261632340.19853@jikos.suse.cz>
Date: Wed, 26 Nov 2008 22:06:00 +0100 (CET)
Subject: Re: [PATCH 1/1] HID: Apple alu wireless keyboards are bluetooth 
     devices
From: Tobias =?iso-8859-1?Q?M=FCller?= <Tobias_Mueller@twam.info>
To: "Jiri Kosina" <jkosina@suse.cz>
Cc: "Jan Scholz" <scholz@fias.uni-frankfurt.de>,
       "Tobias Mueller" <tobias_mueller@twam.info>, jirislaby@gmail.com,
       linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> The one I own is a USB_DEVICE_ID_APPLE_ALU_WIRELESS_ISO, german layout,
>> with bluetooth, unfortunately I don't have access to a usb variant.
>
> Tobias Mueller added these device IDs, so persumably he has tested it and
> could provide some insight. I don't have the hardware myself, so I have no
> idea whether there are only Bluetooht variants, or even USB are available.
>
> Tobias?

I own the USB variant and these are the right id for that. The wireless
IDs were from another patch I merged together with mine. I don't have a
wireless version.

Regards
  Tobias

