Return-Path: <linux-kernel-owner+w=401wt.eu-S933696AbXK2XX6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933696AbXK2XX6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 18:23:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760762AbXK2XXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 18:23:43 -0500
Received: from smtp-out001.kontent.com ([81.88.40.215]:36600 "EHLO
	smtp-out001.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756215AbXK2XXm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 18:23:42 -0500
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: Jaime Velasco Juan <jsagarribay@gmail.com>
Subject: Re: Add the infamous Huawei E220 to option.c
Date: Fri, 30 Nov 2007 00:23:07 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Johann Wilhelm <johann.wilhelm@student.tugraz.at>,
       Rui Santos <rsantos@grupopie.com>, Pete Zaitcev <zaitcev@redhat.com>,
       linux-usb@vger.kernel.org, preining@logic.at,
       kristoffer.ericson@gmail.com, drussell@redhat.com,
       linux-kernel@vger.kernel.org
References: <20071128161305.b01167b3.zaitcev@redhat.com> <20071129150550.86453nubw8i5xi68@webmail.tugraz.at> <20071129185339.GA10445@singular.local>
In-Reply-To: <20071129185339.GA10445@singular.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200711300023.08999.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 29. November 2007 19:53:39 schrieb Jaime Velasco Juan:
> Hi,
>
> El jue. 29 de nov. de 2007, a las 15:05:50 +0100, Johann Wilhelm escribió:
> > If everything's working please also add code to also support the other
> > E220 device... so both PID 0x1003 and 0x1004 should be treaded the same
> > way...
> >
> > to test the device with the 0x1004-PID maybe Jaime Velasco
> > <jsagarribay@gmail.com> could be asked.. he initialy added the lines for
> > this device in option.c
>
> The following patch works for me (on kernel 2.6.23).

Jaime, please add your signed off by line and resend the patch with
both lines to Greg.

Signed-off-by: Oliver Neukum <oneukum@suse.de>

	Regards
		Oliver
