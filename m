Return-Path: <linux-kernel-owner+w=401wt.eu-S933837AbZKXSTD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933837AbZKXSTD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 13:19:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933680AbZKXSTC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 13:19:02 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:55641 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933553AbZKXSTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 13:19:00 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Gernot Hillier <gernot@hillier.de>
Subject: Re: [PATCH] Add support for Mobilcom Debitel USB UMTS Surf-Stick to option driver
Date: Tue, 24 Nov 2009 19:19:10 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.32-rc6-0.1-default; KDE/4.3.1; x86_64; ; )
Cc: Matthias Urlichs <smurf@smurf.noris.de>,
       "Greg Kroah-Hartman" <gregkh@suse.de>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <4B08F18C.3040904@hillier.de> <200911220920.16717.oliver@neukum.org> <4B0C1F41.2060101@hillier.de>
In-Reply-To: <4B0C1F41.2060101@hillier.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200911241919.10895.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 24. November 2009 19:00:33 schrieb Gernot Hillier:
> As you might have expected, I have no detailed spec about the device 
> which could explain this. I can only say that the device reacts on AT 
> commands on ttyUSB1 and ttyUSB2 while ttyUSB0 seems to serve other
>  purposes.
> 
> What do you think - shall I disable sending the usb control message 
> depending on bInterfaceNumber? Any better ideas?

I have no better idea.

	Regards
		Oliver

