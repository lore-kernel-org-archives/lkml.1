Return-Path: <linux-kernel-owner+w=401wt.eu-S1757943AbXENR47@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757943AbXENR47 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 13:56:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756576AbXENR4x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 13:56:53 -0400
Received: from mcr-smtp-001.bulldogdsl.com ([212.158.248.7]:1050 "EHLO
	mcr-smtp-001.bulldogdsl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756091AbXENR4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 13:56:52 -0400
X-Spam-Abuse: Please report all spam/abuse matters to abuse@bulldogdsl.com
From: Alistair John Strachan <s0348365@sms.ed.ac.uk>
To: Oliver Neukum <oliver@neukum.org>
Subject: Re: converting appletouch to usb autosuspend...
Date: Mon, 14 May 2007 18:56:37 +0100
User-Agent: KMail/1.9.6
Cc: Soeren Sonnenburg <kernel@nn7.de>, linux-usb-devel@lists.sourceforge.net,
       Linux Kernel <linux-kernel@vger.kernel.org>, maxk@qualcomm.com
References: <1178995886.4168.10.camel@localhost> <200705140153.03084.s0348365@sms.ed.ac.uk> <200705140750.40458.oliver@neukum.org>
In-Reply-To: <200705140750.40458.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705141856.37923.s0348365@sms.ed.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 May 2007 06:50:39 Oliver Neukum wrote:
> Am Montag, 14. Mai 2007 02:53 schrieb Alistair John Strachan:
> > > What did you use instead of hci_usb then ? usbkbd ? This won't give you
> > > the special keys etc...
> >
> > Sorry, I wasn't clear. hci_usb is actually part of the BlueZ stack, it's
> > got nothing to do with the keyboard. I unloaded both appletouch AND
> > hci_usb.
>
> If you want large power savings from USB autosuspend, all
> loaded drivers must support autosuspend. The HCD can suspend
> only if all connected devices are suspended.
> Are you willing to test patches for HID & the new last_busy based
> usb core infrastructure?

Of course.

-- 
Cheers,
Alistair.

Final year Computer Science undergraduate.
1F2 55 South Clerk Street, Edinburgh, UK.
