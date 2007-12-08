Return-Path: <linux-kernel-owner+w=401wt.eu-S1756839AbXLHNMH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756839AbXLHNMH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 08:12:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753062AbXLHNLz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 08:11:55 -0500
Received: from moutng.kundenserver.de ([212.227.126.183]:58647 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457AbXLHNLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 08:11:54 -0500
Message-ID: <475A9810.4070104@anagramm.de>
Date: Sat, 08 Dec 2007 14:11:44 +0100
From: Clemens Koller <clemens.koller@anagramm.de>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Nick Warne <nick@ukfsn.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: scsi_wait_scan Kconfig option
References: <20071207191242.71a9cc3e@linuxamd.linicks.net>
In-Reply-To: <20071207191242.71a9cc3e@linuxamd.linicks.net>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1/sxWWdZA7gw9s5HfGS4s7KiJFSwvxUr7W1xBm
 d2bze3k5hOMBHzFyvopgKDDUL85IAU1cMnAx3lsfHYCkgdBOoX
 AOnXn8T3hmvikoTT2z1SQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Warne schrieb:
> I am bringing this up again - primarily as I forgot about it after
> patching my build tree ages ago:
> 
> http://lkml.org/lkml/2007/10/27/68

Please see the patch I sent some days ago, which does the very
same thing: http://marc.info/?l=linux-kernel&m=119677244318528&w=2

I would extend the help text a bit more to make clear what it
really does, since there is not much documentation around.

> I try not to build a modular kernel, but only have modules ON due to
> nVidia (sigh).  So I was semi-surprised when I saw the scsi_wait_scan
> module being built again, yet NO WHERE in menuconfig is it present to
> turn OFF.  Even if I hand edit .config, make puts it back again...

True...

Regards,
-- 
Clemens Koller
_______________________________
R&D Imaging Devices
Anagramm GmbH
Rupert-Mayer-Str. 45/1
81379 Muenchen
Germany

http://www.anagramm-technology.com
Phone: +49-89-741518-50
Fax: +49-89-741518-19
