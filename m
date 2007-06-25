Return-Path: <linux-kernel-owner+w=401wt.eu-S1753219AbXFYLu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219AbXFYLu0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 07:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751350AbXFYLuQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 07:50:16 -0400
Received: from rudy.mif.pg.gda.pl ([153.19.42.16]:47698 "EHLO
	rudy.mif.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070AbXFYLuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 07:50:15 -0400
Date: Mon, 25 Jun 2007 13:50:06 +0200 (CEST)
From: =?ISO-8859-2?Q?Tomasz_K=B3oczko?= <kloczek@rudy.mif.pg.gda.pl>
To: Takashi Iwai <tiwai@suse.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: Is it time for remove (crap) ALSA from kernel tree ?
In-Reply-To: <s5h4pkwi9u0.wl%tiwai@suse.de>
Message-ID: <Pine.BSO.4.63.0706251337180.25800@rudy.mif.pg.gda.pl>
References: <Pine.BSO.4.63.0706241943190.25800@rudy.mif.pg.gda.pl>
 <s5h4pkwi9u0.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="0-1869983456-1182772206=:25800"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--0-1869983456-1182772206=:25800
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8BIT

On Mon, 25 Jun 2007, Takashi Iwai wrote:
[..]
>> Any plans for doing this ?
>
> Did you count the number of devices that tree supports?

What is harder ? Bring ALSA API to the same level of functionalities as 
OSS provides or port (FOSS) ALSA device drivers to OSS ?

> You'll loose the support of all new laptops and mobos sold in the last
> year :)

You are loosing point lack of will ALSA developers to make this useable, 
and well documented. OSS it is stabkle API specyfication with good 
reputation. ALSA still is in development stage.

> Honestly, I'm not fully against changing the current code base (or
> crap, whatever, any childish name).  There are indeed many misdesigns.
> But, replacing with the above is no option, IMO.  The OSS have also
> many misdesigns, so the same argument would start again.  One should
> learn something from history...

OSS is at all misdesigned ? or in some points ? if partialy it was bad (in 
time start work on ALSA) why was not improved ?
For me it looks like ALSA developers don't know "don't move - improve" 
sentence.

kloczek
PS. /me still waiting for simple yes or no answer on my qustion from 
responsible people.
For example: if Hannu or other OSS developer will bring some patches it 
will be integrated or not in main tree ?
-- 
-----------------------------------------------------------
*Ludzie nie maj± problemów, tylko sobie sami je stwarzaj±*
-----------------------------------------------------------
Tomasz K³oczko, sys adm @zie.pg.gda.pl|*e-mail: kloczek@rudy.mif.pg.gda.pl*
--0-1869983456-1182772206=:25800--
