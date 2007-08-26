Return-Path: <linux-kernel-owner+w=401wt.eu-S1754816AbXHZX1h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816AbXHZX1h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2007 19:27:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752787AbXHZX12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Aug 2007 19:27:28 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:13335 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733AbXHZX10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2007 19:27:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=bogh1IFKE9jqVkVHwbHXviZX4Kw6AhPuGJwqSvcUJW2l8NoMlvqNSO6XGtBU4/0supz4zv0+weRyBiAA2gOUUP5M7DqFioK9JG1ocTWy10ehZVTzeYT1JApxTYu51OdNZeadVkzCjx+5WMSmv76I8YN4DpNk/VVmM6ivHFjKB0c=
Message-ID: <6bffcb0e0708261627s12e5a9acqef92d0261264a40c@mail.gmail.com>
Date: Mon, 27 Aug 2007 01:27:25 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: patrizio.bassi@gmail.com
Subject: Re: libata not working for sis5533
Cc: "Kernel," <linux-kernel@vger.kernel.org>,
       "IDE/ATA development list" <linux-ide@vger.kernel.org>,
       "Alan Cox" <alan@redhat.com>,
       "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>
In-Reply-To: <46D132C5.5000803@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46D132C5.5000803@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

[Adding IDE wizards to CC]

On 26/08/07, Patrizio Bassi <patrizio.bassi@gmail.com> wrote:
> My sis630 chipset shipped with Asus A1000
> doesn't work properly with suspend with ide drivers
> (http://bugzilla.kernel.org/show_bug.cgi?id=7077)
>
> i tried to switch to libata but i cannot boot.
> I've enabled generic ide and sis specific code, both in-kernel. of
> course scsi too.
>
> when i boot i get: irq #14 nobody cared and stop
>
> i have to remove battery to reboot pc.
> I'm using 2.6.22.5, but i never got any libata kernel working.
>
> Patrizio
>
> ps. i'm writing from my desktop as i'm doing hardware mainteinance on
> the laptop and could not boot it
>
> Please CC me.
>
> lspci:
> 00:00.0 Host bridge: Silicon Integrated Systems [SiS] 630 Host (rev 11)
> 00:00.1 IDE interface: Silicon Integrated Systems [SiS] 5513 [IDE] (rev d0)
> 00:01.0 ISA bridge: Silicon Integrated Systems [SiS] SiS85C503/5513 (LPC
> Bridge)
> 00:01.1 Ethernet controller: Silicon Integrated Systems [SiS] SiS900
> PCI Fast Ethernet (rev 80)
> 00:01.2 USB Controller: Silicon Integrated Systems [SiS] USB  1.0
> Controller (rev 07)
> 00:01.3 USB Controller: Silicon Integrated Systems [SiS] USB 1.0
> Controller (rev 07)
> 00:01.4 Multimedia audio controller: Silicon Integrated Systems [SiS]
> SiS PCI Audio Accelerator (rev 01)
>  00:01.6 Modem: Silicon Integrated Systems [SiS] AC'97 Modem
> Controller (rev a0)
> 00:02.0 PCI bridge: Silicon Integrated Systems [SiS] Virtual
> PCI-to-PCI bridge (AGP)
> 00:0a.0 CardBus bridge: Ricoh Co Ltd RL5c476 II (rev 80)
> 00:0a.1 CardBus bridge: Ricoh Co Ltd RL5c476 II (rev 80)
> 01:00.0 VGA compatible controller: Silicon Integrated Systems [SiS]
> 630/730 PCI/AGP VGA Display Adapter (rev 11)

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
