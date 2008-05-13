Return-Path: <linux-kernel-owner+w=401wt.eu-S1759465AbYEMJH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759465AbYEMJH1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 05:07:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757198AbYEMJHO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 05:07:14 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:40964 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756934AbYEMJHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 05:07:13 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: NOvell
To: Priit Laes <plaes@plaes.org>, USB list <linux-usb@vger.kernel.org>
Subject: Re: OOPS in ov511 driver
Date: Tue, 13 May 2008 11:07:13 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel <linux-kernel@vger.kernel.org>, mmcclell@bigfoot.com
References: <1210666197.30196.7.camel@localhost>
In-Reply-To: <1210666197.30196.7.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805131107.13958.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag 13 Mai 2008 10:09:57 schrieb Priit Laes:
> Hey!
> 
> I got following oops when unplugging some Creative-labeled webcam using
> ov511 driver. Machine is Core2 Duo 64-bit, Gentoo Linux, kernel is
> 2.6.25-05301-gc3bf9bc, gcc is 4.2.3 (Gentoo 4.2.3 p1.0)
> 
> usb 2-1: USB disconnect, address 7
> ov511: ERROR: urb->status=-108: Unknown
> ov511: usb_submit_urb() ret -19
> ov511: ERROR: urb->status=-108: Unknown
> ov511: usb_submit_urb() ret -19
> usb 2-1: new full speed USB device using uhci_hcd and address 8
> usb 2-1: configuration #1 chosen from 1 choice
> ov511: USB OV511+ video device found
> ov511: model: Creative Labs WebCam 3
> ov511: Sensor is an OV7620
> ov511: Device at usb-0000:00:1d.0-1 registered to minor 0

Are you replugging the device?

	Regards
		Oliver

