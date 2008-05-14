Return-Path: <linux-kernel-owner+w=401wt.eu-S1761686AbYENIN1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761686AbYENIN1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 04:13:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753812AbYENINN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 04:13:13 -0400
Received: from slowhand.arndnet.de ([88.198.19.76]:55255 "EHLO mail.unitix.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753151AbYENINL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 04:13:11 -0400
X-Greylist: delayed 1462 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 May 2008 04:13:11 EDT
Message-ID: <482A995C.7040806@arndnet.de>
Date: Wed, 14 May 2008 09:48:44 +0200
From: Arnd Hannemann <arnd@arndnet.de>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@medozas.de>
CC: Arnd Hannemann <arnd@arndnet.de>, Roland <devzero@web.de>,
       tvrtko@ursulin.net, pernegger@gmail.com, snitzer@gmail.com,
       zorglub_olsen@hotmail.com, renatoyamane@mandic.com.br,
       linux-kernel@vger.kernel.org
Subject: Re: WD doesn`t use disks with Linux - was Re: Re:Western Digital
 GreenPower drives and Linux
References: <003201c8b53c$67ff02d0$6400a8c0@bui.materna.com> <482A062B.3010308@arndnet.de> <alpine.LNX.1.10.0805132343470.448@fbirervta.pbzchgretzou.qr>
In-Reply-To: <alpine.LNX.1.10.0805132343470.448@fbirervta.pbzchgretzou.qr>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Tuesday 2008-05-13 23:20, Arnd Hannemann wrote:
>> Well the answer was probably just from a first level support person so
>> nothing one should get excited about.
>> Anyway to the high Load_Cycle_Count; if I understood the technology
>> correctly the WD GreenPower drives are exactly "Green" because they
> 
> I don't find it Green when I have to buy new disks because of
> their detrimental parking technique.
> 
>> unload the heads on a plastic ramp (no landing zone!) quite often during
> 
> ramp or LZ, it's quite a force with which the head is parked.
> 

Well I'm no expert, but I would say comparing to the normal wear out due
to use (seeking, bearing wear out, vibrations, spin up, bumps) the
factor of a controlled unload/load cycle on a plastic ramp is probably
negligible.

BTW: my hitachi notebook drive, which I believe has a similar
load/unload technology has:
> 193 Load_Cycle_Count        0x0032   057   057   000    Old_age   Always       -       258528/258360

And it didn't fail on me yet...
Of course this is just one data point.

Regards,
Arnd Hannemann
