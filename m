Return-Path: <linux-kernel-owner+w=401wt.eu-S1753209AbZIETsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209AbZIETsQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Sep 2009 15:48:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753117AbZIETsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Sep 2009 15:48:10 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:49746 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107AbZIETsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Sep 2009 15:48:06 -0400
From: Christian =?utf-8?q?Kr=C3=A4mer?= <christian@kraemer-eu.de>
Organization: Privat
To: Wolfram Sang <w.sang@pengutronix.de>
Subject: Re: yenta_socket: PCMCIA-Cards are not recognised by kernel
Date: Sat, 5 Sep 2009 21:46:10 +0200
User-Agent: KMail/1.9.9
Cc: linux-pcmcia@lists.infradead.org, Frans Pop <elendil@planet.nl>,
       Peter Stuge <peter@stuge.se>, linux-kernel@vger.kernel.org
References: <200909021856.29565.christian@kraemer-eu.de> <200909042239.17180.christian@kraemer-eu.de> <20090905143022.GD3171@pengutronix.de>
In-Reply-To: <20090905143022.GD3171@pengutronix.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200909052146.10779.christian@kraemer-eu.de>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX197nsjO1tw/F8hXwzL8BvpbWvXrL3TDX94I+is
 rQAPapuxoHi4pW2lc25OE3qQHWR8ZmPrFEHzBYE13FHhE/Fr8j
 c+he9r1kjvLlpzoYY+HYVKuFw1celCP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 05 September 2009 16:30:22 Wolfram Sang wrote:
> (As a first note: The dmesg output suffers from linebreaks. Please make
> sure your MUA doesn't split up the logs.)
>
> > Even I installed gentoo with the 2.6.30.5 downloaded from kernel.org.
>
> Good. The sysfs-errors went away, too.
>
> > [    0.000000] IBM Thinkpad 600 Series 2645 detected: force use of
> > acpi=noirq
>
> Uh oh. Which BIOS version do you have?

The configuration interface displays: IBET41WW, 05/12/99.
I know this isn't the newest version, but I don't have a floppy device for the
laptop. I'll try to brun a dos cd with el torito folppy emulation, maybe i can
upgrade it this way.

> > [    1.179419] ACPI: ACPI Dock Station Driver: 1 docks/bays found
>
> Well, looks like you are using a docking station. Does it work without the
> docking station? What is its name? There seem to be more problems with
> those, for example:
>
> http://bugzilla.kernel.org/show_bug.cgi?id=10805

Strange, I'dont use a docking station. I have not even got one.

> > [    1.183173] * Found PM-Timer Bug on the chipset. Due to workarounds
> > for a bug, [    1.183191] * this clock source is slow. Consider trying
> > other clock sources
>
> Wow, there seem to be quite some issues with this laptop...

unfortunately...

> To make sure: Do regular PC Cards (non-CardBus) work with/without the
> docking station? (I would assume that...)

With regular PC Cards you mean 16 bit cards, don't you? I have only those one
wlan card, but i can try to organisate one.

