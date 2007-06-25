Return-Path: <linux-kernel-owner+w=401wt.eu-S1756071AbXFYNlx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756071AbXFYNlx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 09:41:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752251AbXFYNlq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 09:41:46 -0400
Received: from rudy.mif.pg.gda.pl ([153.19.42.16]:12395 "EHLO
	rudy.mif.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166AbXFYNlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 09:41:46 -0400
Date: Mon, 25 Jun 2007 15:41:44 +0200 (CEST)
From: =?ISO-8859-2?Q?Tomasz_K=B3oczko?= <kloczek@rudy.mif.pg.gda.pl>
To: Gabor Gombas <gombasg@sztaki.hu>
cc: Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: Is it time for remove (crap) ALSA from kernel tree ?
In-Reply-To: <20070625130147.GB31762@boogie.lpds.sztaki.hu>
Message-ID: <Pine.BSO.4.63.0706251538060.25800@rudy.mif.pg.gda.pl>
References: <Pine.BSO.4.63.0706241943190.25800@rudy.mif.pg.gda.pl>
 <20070624200837.16e11305@the-village.bc.nu> <Pine.BSO.4.63.0706242113530.25800@rudy.mif.pg.gda.pl>
 <20070624215724.025a5de5@the-village.bc.nu> <Pine.BSO.4.63.0706251052380.25800@rudy.mif.pg.gda.pl>
 <s5h3b0gi9mp.wl%tiwai@suse.de> <Pine.BSO.4.63.0706251308020.25800@rudy.mif.pg.gda.pl>
 <20070625130147.GB31762@boogie.lpds.sztaki.hu>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="0-1315486494-1182778904=:25800"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--0-1315486494-1182778904=:25800
Content-Type: TEXT/PLAIN; charset=iso-8859-2; format=flowed
Content-Transfer-Encoding: 8BIT

On Mon, 25 Jun 2007, Gabor Gombas wrote:

> On Mon, Jun 25, 2007 at 01:36:23PM +0200, Tomasz K³oczko wrote:
>
>> ALSA still does not provides good soud devices virtualization for more then
>> one application. Each day I'm using bludy words when I'm try to use skype
>> which oppens /dev/mixer [...]
>
> Not true anymore:
>
> skype   32381 gombasg  mem       CHR      116,7               4663 /dev/snd/pcmC0D0p
> skype   32381 gombasg   32r      CHR      116,2               4301 /dev/snd/timer
> skype   32381 gombasg   34u      CHR      116,7               4663 /dev/snd/pcmC0D0p
> skype   32381 gombasg   35u      CHR      116,9               4674 /dev/snd/controlC0
>
> I do not even have the OSS compat interface enabled in my kernel.

Sorry but skype does not for me after switching to ALSA (on skype cfg 
level). 
Probably ALSA developers can explain why :>
All above on fresh FC6 and 1.3.53 skype.

kloczek
-- 
-----------------------------------------------------------
*Ludzie nie maj± problemów, tylko sobie sami je stwarzaj±*
-----------------------------------------------------------
Tomasz K³oczko, sys adm @zie.pg.gda.pl|*e-mail: kloczek@rudy.mif.pg.gda.pl*
--0-1315486494-1182778904=:25800--
