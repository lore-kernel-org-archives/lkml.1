Return-Path: <linux-kernel-owner+w=401wt.eu-S1760068AbZDWWJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760068AbZDWWJg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 18:09:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757005AbZDWWJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 18:09:27 -0400
Received: from yoda.london.02.net ([82.132.130.151]:44116 "EHLO mail.o2.co.uk"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756961AbZDWWJ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 18:09:26 -0400
X-Greylist: delayed 354 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 Apr 2009 18:09:26 EDT
Message-ID: <49F0E58D.4050201@f2s.com>
Date: Thu, 23 Apr 2009 23:02:53 +0100
From: Bernd Porr <BerndPorr@f2s.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: David Woodhouse <dwmw2@infradead.org>, maximilian attems <max@stro.at>,
       "Christopher J. Harrer" <charrer@alacritech.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] linux-firmware updates
References: <20090422233828.GA17239@kroah.com>
In-Reply-To: <20090422233828.GA17239@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thanks, Greg.

/Bernd

www:    http://www.berndporr.me.uk/
         http://www.linux-usb-daq.co.uk/
Mobile: +44 (0)7840 340069
Work:   +44 (0)141 330 5237
         University of Glasgow
         Department of Electronics & Electrical Engineering
         Room 519, Rankine Building, Oakfield Avenue,
         Glasgow, G12 8LT


Greg KH wrote:
> The following changes since commit a1b8f9ee2c559adc85a3a87e8352f451ad4747b4:
>   David Woodhouse (1):
>         Merge branch 'master' of http://git.decadent.org.uk/git/linux-firmware
> 
> are available in the git repository at:
> 
>   gregkh@master.kernel.org:/pub/scm/linux/kernel/git/gregkh/linux-firmware.git gregkh
> 
> Bernd Porr (2):
>       Add usbdux firmware
>       Add the source code for the usbdux firmware
> 
> maximilian attems (1):
>       Alacritech: reword firmware license to be distributable
> 
>  WHENCE                         |   16 +-
>  usbdux/Makefile_dux            |   19 +
>  usbdux/README.dux              |   15 +
>  usbdux/fx2-include.asm         |  164 ++++++
>  usbdux/usbdux_firmware.asm     | 1184 ++++++++++++++++++++++++++++++++++++++++
>  usbdux/usbduxfast_firmware.asm |  547 +++++++++++++++++++
>  usbdux_firmware.bin            |  Bin 0 -> 1770 bytes
>  usbduxfast_firmware.bin        |  Bin 0 -> 999 bytes
>  8 files changed, 1941 insertions(+), 4 deletions(-)
>  create mode 100644 usbdux/Makefile_dux
>  create mode 100644 usbdux/README.dux
>  create mode 100644 usbdux/fx2-include.asm
>  create mode 100644 usbdux/usbdux_firmware.asm
>  create mode 100644 usbdux/usbduxfast_firmware.asm
>  create mode 100644 usbdux_firmware.bin
>  create mode 100644 usbduxfast_firmware.bin
> 
