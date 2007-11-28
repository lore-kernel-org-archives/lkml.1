Return-Path: <linux-kernel-owner+w=401wt.eu-S1758614AbXK1OAe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758614AbXK1OAe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 09:00:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752679AbXK1OAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 09:00:24 -0500
Received: from services.erkkila.org ([24.97.94.217]:51387 "EHLO erkkila.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751864AbXK1OAX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 09:00:23 -0500
X-Greylist: delayed 319 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Nov 2007 09:00:23 EST
Message-ID: <474D7336.4000102@erkkila.org>
Date: Wed, 28 Nov 2007 08:55:02 -0500
From: Paul Erkkila <pee@erkkila.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
CC: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>
Subject: Re: ACPI related Warning in 2.6.24-rc3-git2
References: <20071127150557.GA4365@ics.muni.cz> <200711271637.13036.rjw@sisk.pl> <20071128041155.GB18131@khazad-dum.debian.net> <20071128083153.GL4365@ics.muni.cz>
In-Reply-To: <20071128083153.GL4365@ics.muni.cz>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Lukas Hejtmanek wrote:
> On Wed, Nov 28, 2007 at 02:11:55AM -0200, Henrique de Moraes Holschuh wrote:
>> On Tue, 27 Nov 2007, Rafael J. Wysocki wrote:
>>>> in recent kernel, I got the following warnings while booting. It's ACPI
>>>> related. Does anybode care? Lenovo ThinkPad T61 (6465CTO).
>> Could we know the BIOS version, please?
> 
> 7LET56WW (1.26 ) (according to hal, 1.26 is definitely correct, can be seen in
> BIOS as well)
> 

I'm seeing the same thing here, on a similar machine ( 6459CTO ). I
pulled the source from kernel git last night to test it.


Bios:
thinkpad_acpi: ThinkPad BIOS 7LET56WW (1.26 ), EC 7KHT22WW-1.06




-pee

