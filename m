Return-Path: <linux-kernel-owner+w=401wt.eu-S1753861AbZHBVWA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861AbZHBVWA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 17:22:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753798AbZHBVV7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 17:21:59 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:51987 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753791AbZHBVV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 17:21:59 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Alex Riesen <raa.lkml@gmail.com>
Subject: Re: Oops in CDC ACM after an Openmoko phone (neo1973) changes its usb interface from ACM to Ethernet
Date: Sun, 2 Aug 2009 23:22:35 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.31-rc4-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
       Oliver Neukum <oliver@neukum.name>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Greg Kroah-Hartman" <greg@kroah.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <81b0412b0908021339s739c07edvd4d5eb4c21cfa167@mail.gmail.com> <Pine.LNX.4.44L0.0908021650020.14120-100000@netrider.rowland.org> <81b0412b0908021409h73fc2fcfo64c4ba9ee1f0d552@mail.gmail.com>
In-Reply-To: <81b0412b0908021409h73fc2fcfo64c4ba9ee1f0d552@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908022322.36343.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, 2. August 2009 23:09:37 schrieb Alex Riesen:
> So, I connect the device, run its bootloader, which causes
> a CDC ACM interface to appear. The /dev/ttyACM0 node
> appears, and I open it (with minicom). Then I just switch
> the device off and kernel oopses with:

It oopses _before_ you terminate minicom?

	Regards
		Oliver

