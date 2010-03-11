Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489Ab0CKHib (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 02:38:31 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:53896 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753106Ab0CKHia convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 02:38:30 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Ole Reier Ulland <ole.reier@netcom.no>
Subject: Re: ZTE MF636 USB modem is not supported
Date: Thu, 11 Mar 2010 08:37:58 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc1-0.1-default; KDE/4.3.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, USB list <linux-usb@vger.kernel.org>
References: <201003110008.58644.ole.reier@netcom.no>
In-Reply-To: <201003110008.58644.ole.reier@netcom.no>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201003110837.58659.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 11. März 2010 00:08:58 schrieb Ole Reier Ulland:
> I have reported this a while ago to the Mandriva bugzilla, but I cannot see if 
> anyone is doing anything about it. So now I just want to send the link to this 
> e-mail address to get a reply and some understanding.
> 
> https://qa.mandriva.com/show_bug.cgi?id=57165

Maybe Mandriva did not report it upstream.
 
> [root@Dell_Dim Mine_Filer_1_FAT]# uname -a
> Linux Dell_Dim 2.6.31.12-desktop-1mnb #1 SMP Tue Jan 26 03:35:36 EST 2010 i686 
> Intel(R) Pentium(R) 4 CPU 2.80GHz GNU/Linux
> 
> Is it fixed already maybe? Is there another kernel that I can use?

Possible but unlikely. You should try the latest stable kernel.(2.6.33.x)
 
> Is there anything else I can do to help this along?

Post "dmesg" from the moment you plug the modem in and "lsusb -v"
And post them to the correct list, the USB list.

	Regards
		Oliver
