Return-Path: <linux-kernel-owner+w=401wt.eu-S1754777AbZICHFp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777AbZICHFp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 03:05:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754737AbZICHFo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 03:05:44 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:56501 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754675AbZICHFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 03:05:44 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Maciej Rutecki <maciej.rutecki@gmail.com>, greg@kroah.com
Subject: Re: [2.6.31-rc8] Problem with detect USB devices
Date: Thu, 3 Sep 2009 09:07:01 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.31-rc4-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-usb@vger.kernel.org
References: <8db1092f0909020629v5aab79d8lbfcc8c214622787c@mail.gmail.com> <200909021542.11767.oliver@neukum.org> <8db1092f0909020715g3e6f9815w96efc801cc18e3bc@mail.gmail.com>
In-Reply-To: <8db1092f0909020715g3e6f9815w96efc801cc18e3bc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909030907.02321.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 2. September 2009 16:15:28 schrieb Maciej Rutecki:
> KERNEL[1251900287.925994] remove
> /devices/pci0000:00/0000:00:1d.7/usb1/1-1/1-1:1.0/host4 (scsi)
> KERNEL[1251900287.926058] remove
> /devices/pci0000:00/0000:00:1d.7/usb1/1-1/1-1:1.0 (usb)

You are definitely seeing the correct kernel events.
So it must be an indirect problem.

Greg, any changes in sysfs between rc7 and rc8?

	Regards
		Oliver

