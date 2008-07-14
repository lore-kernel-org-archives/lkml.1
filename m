Return-Path: <linux-kernel-owner+w=401wt.eu-S1757213AbYGNHYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757213AbYGNHYQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 03:24:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754683AbYGNHYF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 03:24:05 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:50179 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754592AbYGNHYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 03:24:04 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: NOvell
To: eng_azza_kamal@hotmail.com
Subject: Re: USB Mounting Problem
Date: Mon, 14 Jul 2008 09:24:44 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <4064057.21216044621697.JavaMail.root@wombat.diezmil.com>
In-Reply-To: <4064057.21216044621697.JavaMail.root@wombat.diezmil.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807140924.44787.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag 14 Juli 2008 16:10:21 schrieb eng_azza_kamal@hotmail.com:
> 
> Dear all , 
> 
> I have linux kernel running on an ARM platform. The problem is that the linux kernel doesn't recognize the USB flash if it was inserted before booting up the system.
> If the flash is inserted after the boot up of the kernel the flash is given the node /dev/sda1 or /dev/sdb1 and I can mount it. 
> My question is how to recognize the flash if it was inserted in the system before booting of the kernel. 
> I recompiled the kernel to include both scsi and usb storage (not to be as modules) but this doesn't work.
> 
> Need your support please
> 
> --
> This message was sent on behalf of eng_azza_kamal@hotmail.com at openSubscriber.com
> http://www.opensubscriber.com/messages/linux-kernel@vger.kernel.org/topic.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

You are asking on the wrong list. Go to:

usb-storage (at) lists.one-eyed-alien.net

Please include dmesg in your bug report, preferably from a kernel compiled
with CONFIG_USB_STORAGE_DEBUG.

	Regards
		Oliver


