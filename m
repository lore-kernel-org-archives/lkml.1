Return-Path: <linux-kernel-owner+w=401wt.eu-S1758200AbXLaAb1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758200AbXLaAb1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 19:31:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754477AbXLaAbO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 19:31:14 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:59631 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758225AbXLaAbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 19:31:13 -0500
Date: Mon, 31 Dec 2007 01:31:12 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Carlos Corbacho <carlos@strangeworlds.co.uk>
cc: oakad@exemail.com.au, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, drzeus@drzeus.cx,
       Alex Dubov <oakad@yahoo.com>
Subject: Re: [PATCH] [MEMSTICK] Initial commit for Sony MemoryStick support
In-Reply-To: <200712310001.15395.carlos@strangeworlds.co.uk>
Message-ID: <Pine.LNX.4.64.0712310123540.2093@fbirervta.pbzchgretzou.qr>
References: <1198465597-14059-1-git-send-email-oakad@exemail.com.au>
 <200712310001.15395.carlos@strangeworlds.co.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Dec 31 2007 00:01, Carlos Corbacho wrote:
>On Monday 24 December 2007 03:06:37 oakad@exemail.com.au wrote:
>> From: Alex Dubov <oakad@yahoo.com>
>>
>> Sony MemoryStick cards are used in many products manufactured by Sony. They
>> are available both as storage and as IO expansion cards. Currently, only
>> MemoryStick Pro storage cards are supported via TI FlashMedia MemoryStick
>> interface.

Actually... my MS slot on PCG-U3 is recognized through usb_storage.
