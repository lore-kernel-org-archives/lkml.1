Return-Path: <linux-kernel-owner+w=401wt.eu-S934282AbZGQJUF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934282AbZGQJUF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 05:20:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934273AbZGQJUE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 05:20:04 -0400
Received: from ppsw-5.csi.cam.ac.uk ([131.111.8.135]:54611 "EHLO
	ppsw-5.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934259AbZGQJUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 05:20:03 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4A604246.5060204@gmail.com>
Date: Fri, 17 Jul 2009 09:20:06 +0000
From: Jonathan Cameron <Jonathan.Cameron@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090715)
MIME-Version: 1.0
To: Robert Emanuele <rob@emanuele.us>
CC: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: SDIO Stack and Device Support
References: <9f53b4330907161718ydbac090k2afc7a749fc9f6f2@mail.gmail.com>
In-Reply-To: <9f53b4330907161718ydbac090k2afc7a749fc9f6f2@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Emanuele wrote:
> Greetings all,
>
> I'm trying to find out more information about the status of an SDIO
> stack and SDIO devices in the kernel.  I see under drivers/mmc/ some
> SDIO support.
>
> I'm evaluating the potential of getting a Wireless SDIO card to work
> with the 2.6 kernel.  So far all I see in the kernel is support for an
> SDIO UART.  There is a patch on sourceforge for an SDIO stack and
> drivers from Atheros but that is for 2.6.18.  Is there current support
> for other SDIO wireless devices in the kernel?
>   
There is pretty good support for the Marvell chips (sd8686 etc) in the
mainline
kernel. Take a look under drivers/net/wireless/libertas/

I've also copied in the linux-wireless list.





