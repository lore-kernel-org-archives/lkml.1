Return-Path: <linux-kernel-owner+w=401wt.eu-S1754566AbXFYJtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566AbXFYJtW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 05:49:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754573AbXFYJsv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 05:48:51 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:52725 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752424AbXFYJss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 05:48:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:subject:content-type:content-transfer-encoding:from;
        b=sZuAGNso2k86KbLcJ75AsSVtZBEIapBzlb1VrpZHKWk0ljKmXTaDn8Y7AyOolNLymHCa6pUv4qIyNEbo/YhsdR4pFrVyYlxHvZzoWwF+zqB8ikgWI8DAkl02elTDrFd3f+4TZPXvJb4708GLn9F/5M3J3lA2h2zEpJTulZpvfrg=
Message-ID: <467F8F6D.30801@googlemail.com>
Date: Mon, 25 Jun 2007 11:48:29 +0200
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, alsa-devel@alsa-project.org,
       Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@suse.cz>,
       Ben Collins <bcollins@ubuntu.com>,
       Rodrigo Luiz <troops.of.doom@gmail.com>,
       Rik van Riel <riel@surriel.com>, Hugh Dickins <hugh@veritas.com>,
       Petr Vandrovec <petr@vmware.com>, linux-ide@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Rodney Gordon II <meff@spherevision.org>
Subject: [1/2] 2.6.22-rc6: known regressions
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here is a list of some known regressions in 2.6.22-rc6.

Feel free to add new regressions/remove fixed etc.
http://kernelnewbies.org/known_regressions

*STATISTICS* (a.k.a. list of aces)

Name                    Regressions fixed since 21-Jun-2007
Andi Kleen                             1
Hugh Dickins                           1
Jean Delvare                           1



Unclassified

Subject    : Kernel hang on CMOS_READ
References : http://lkml.org/lkml/2007/6/3/138
Submitter  : Rodrigo Luiz <troops.of.doom@gmail.com>
Status     : Unknown



ALSA

Subject    : snd-aoa causes badness in lib/kref.c:33
References : http://bugzilla.kernel.org/show_bug.cgi?id=8513
Submitter  : Ben Collins <bcollins@ubuntu.com>
Handled-By : Takashi Iwai <tiwai@suse.de>
Status     : Unknown



Memory management

Subject    : 2.6.22-rc5-yesterdaygit with VM debug: BUG in mm/rmap.c:66: anon_vma_link ?
References : http://lkml.org/lkml/2007/6/25/45
Submitter  : Petr Vandrovec <petr@vmware.com>
Status     : unknown



SATA/PATA

Subject    : libata IT821X driver still fails! Hard-freezes system
References : http://lkml.org/lkml/2007/6/14/82
Submitter  : Rodney Gordon II <meff@spherevision.org>
Status     : unknown



Regards,
Michal

--
LOG
http://www.stardust.webpages.pl/log/
