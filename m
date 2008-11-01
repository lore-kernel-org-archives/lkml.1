Return-Path: <linux-kernel-owner+w=401wt.eu-S1752829AbYKAMIx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829AbYKAMIx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 08:08:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751430AbYKAMIn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 08:08:43 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:53871 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbYKAMIm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 08:08:42 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: Adam Nielsen <a.nielsen@shikadi.net>
Subject: Re: Can you use the USB HID interface within a driver?
Date: Sat, 1 Nov 2008 13:08:40 +0100
User-Agent: KMail/1.9.9
Cc: LKML Mailinglist <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org
References: <490C4133.30400@shikadi.net>
In-Reply-To: <490C4133.30400@shikadi.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200811011308.41339.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, 1. November 2008 12:44:51 schrieb Adam Nielsen:
> I've tried to find some example code from a driver that already does 
> this (such as a USB keyboard driver) but I'm having some trouble finding 
> one!  The closest drivers I can find are all the ones in 
> drivers/hid/usbhid, but they all seem to be "embedded" in hid-core.c. 
> Does that mean I need to modify hid-core.c to call my driver?
> 
> Or perhaps someone could point me in the direction of a USB HID driver 
> that does things "properly" already?

Please post "lsusb -v" for your device.

	Regards
		Oliver

