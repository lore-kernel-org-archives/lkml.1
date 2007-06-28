Return-Path: <linux-kernel-owner+w=401wt.eu-S1762444AbXF1Lus@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762444AbXF1Lus (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 07:50:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757308AbXF1Luk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 07:50:40 -0400
Received: from rudy.mif.pg.gda.pl ([153.19.42.16]:30383 "EHLO
	rudy.mif.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757083AbXF1Luj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 07:50:39 -0400
Date: Thu, 28 Jun 2007 13:50:37 +0200 (CEST)
From: =?ISO-8859-2?Q?Tomasz_K=B3oczko?= <kloczek@rudy.mif.pg.gda.pl>
To: Patrick Draper <pdraper@gmail.com>
cc: Rene Herman <rene.herman@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Is it time for remove (crap) ALSA from kernel tree ?
In-Reply-To: <4683252B.9010205@gmail.com>
Message-ID: <Pine.BSO.4.63.0706281336260.25800@rudy.mif.pg.gda.pl>
References: <200706271825.17459.ahartmetz@gmail.com> <46829E82.6080804@gmail.com>
 <200706272110.50744.ahartmetz@gmail.com> <4682EEDD.4020501@gmail.com>
 <4682FE5C.5070004@gmail.com> <468315AF.1080105@gmail.com> <4683252B.9010205@gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="0-675228469-1183031437=:25800"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--0-675228469-1183031437=:25800
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8BIT

On Wed, 27 Jun 2007, Patrick Draper wrote:

> Rene Herman wrote:
>> So -- the fact that mixing actually works for you when using libaoss means 
>> software mixing is working correctly for your ALSA setup. The only thing 
>> you should do is _use_ ALSA (natively) and not its OSS emulation so you can 
>> drop the library preload.
>
> Cool. How do I go about figuring out what every app uses? For example, you 
> mentioned that the flash 9 plugin, which I also use, is an ALSA aware 
> application. How do you know? I need the check out everything that I use 
> which needs sound (vmware, skype, kmplayer, etc.) I don't have source code 
> for at least two of those.

If can I join .. (again)
After upgrade to skype 1.4.x all sound output in skype I have only in left 
channel. Serching for skype+left+channel on google shows many people 
have this kind problem :>
ALSA does not privide application mixer settings on application level. 
Some messages on skype forums suggests some workarouds in ~/.asoudrc 
but where is documentation for this part ?
Anywhere are described ALSA diagnostics procedures/technics ?

kloczek
-- 
-----------------------------------------------------------
*Ludzie nie maj± problemów, tylko sobie sami je stwarzaj±*
-----------------------------------------------------------
Tomasz K³oczko, sys adm @zie.pg.gda.pl|*e-mail: kloczek@rudy.mif.pg.gda.pl*
--0-675228469-1183031437=:25800--
