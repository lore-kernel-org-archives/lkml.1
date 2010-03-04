Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755059Ab0CDJRt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 04:17:49 -0500
Received: from mail.gmx.net ([213.165.64.20]:55654 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754621Ab0CDJRo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 04:17:44 -0500
X-Authenticated: #23500402
X-Provags-ID: V01U2FsdGVkX19xyOIjjZJxXJ/l1a0+/S7HX4ci74Kw41ruWw5y1b
	Y8gQf3XQqRNSVs
Date: Thu, 4 Mar 2010 10:17:41 +0100
From: Andre Prendel <andre.prendel@gmx.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Udo van den Heuvel <udovdh@xs4all.nl>, linux-kernel@vger.kernel.org,
       lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] 2.6.33 on jetway nc81-lf board
Message-ID: <20100304091741.GA1995@andre-laptop>
References: <4B8C0598.2060000@xs4all.nl>
 <20100302213709.951ee97b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100302213709.951ee97b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.53000000000000003
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 02, 2010 at 09:37:09PM -0800, Andrew Morton wrote:
> (cc lm-sensors)
> 
> On Mon, 01 Mar 2010 19:21:12 +0100 Udo van den Heuvel <udovdh@xs4all.nl> wrote:
> 
> > Hello,

Hi,

> > 
> > I just compiled 2.6.33 on a Jetway NC81-LF board with AMD 235E CPU.
> > While trying to get lm_sensors to work I get in dmesg stuff like:
> > 
> > f71882fg: Found f71862fg chip at 0x220, revision 18
> > ACPI: I/O resource f71882fg [0x220-0x227] conflicts with ACPI region
> > IP__ [0x225-0x226]
> > ACPI: If an ACPI driver is available for this device, you should use it
> > instead of the native driver
> > ACPI: I/O resource piix4_smbus [0xb00-0xb07] conflicts with ACPI region
> > SOR1 [0xb00-0xb0f]
> > ACPI: If an ACPI driver is available for this device, you should use it
> > instead of the native driver
> > 
> > 
> > No other sensor-related modules are loaded.
> > 
> > What could be wrong?

See lm-sensors FAQ Chapter3 #39:

  http://www.lm-sensors.org/wiki/FAQ/Chapter3#Mysensorshavestoppedworkinginkernel2.6.31

Regards,
Andre
