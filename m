Return-Path: <linux-kernel-owner+w=401wt.eu-S1755834AbZHNLmp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755834AbZHNLmp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 07:42:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754359AbZHNLmo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 07:42:44 -0400
Received: from ppsw-0.csi.cam.ac.uk ([131.111.8.130]:56459 "EHLO
	ppsw-0.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754069AbZHNLmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 07:42:44 -0400
X-Greylist: delayed 1157 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 Aug 2009 07:42:43 EDT
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4A854936.5060409@gmail.com>
Date: Fri, 14 Aug 2009 12:23:34 +0100
From: Jonathan Cameron <Jonathan.Cameron@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090803)
MIME-Version: 1.0
To: Kari Laine <klaine8@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Subject: Re: I2C -bus programming
References: <4A8491E3.4070907@gmail.com>
In-Reply-To: <4A8491E3.4070907@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Copied to i2c mailing list.

> Dear List,
>
> this is my first post here and I am not sure if this is a suitable topic
> here. Anyway I have a Velleman K8000 IO-card and it uses I2C over
> parallel port to communicate.
>
> when I modprobe i2c-parport it does not complain. I tested without card
> connected and it complained so it seems to find the card.
>
> modprobe pcf8591
>
> modprobe i2c-core
>
> modprobe i2c-dev
>
> I am not sure I am doing it right. Should i2c-core probed first ?
>
> anyway now I have
>
> /dev/i2c-0  /dev/i2c-1
>
> Now I don't know whether these i2c-devices refer to this Velleman  board
> or some other i2c-device which happen to be in the computer...
>
> If these devices probably refer to Velleman - then how I can refer
> different i2c-devices on the board.
>
>
> I am totally new to this i2c thing (reading spec at the moment but it
> does not help much with Linux).
>
> I would be very greatfull if some could point me the way - thanks.
>
> Best Regards
> Kari Laine
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>   

