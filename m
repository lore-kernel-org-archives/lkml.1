Return-Path: <linux-kernel-owner+w=401wt.eu-S1754272AbZDPJs2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272AbZDPJs2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 05:48:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754097AbZDPJsU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 05:48:20 -0400
Received: from fmmailgate09.web.de ([217.72.192.184]:44713 "EHLO
	fmmailgate09.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754025AbZDPJsT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 05:48:19 -0400
Date: Thu, 16 Apr 2009 11:48:16 +0200
Message-Id: <672927818@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: linux-kernel@vger.kernel.org
Cc: Dragoslav Zaric <dragoslav.zaric.kd@gmail.com>
Subject: Re: Linux image boot 
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX1+p8bXoBZ5pWLuqjqJJoL/tVjUOGjvzFJ+awQDRn3U6rXzwg
 6VK1iTSLtW6cPPcK1j4afFSqKFTyNJtgw7J2ObZ1SKUJo4S02E=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linux could directly boot from floppy in the past, but that feature has been obsoleted and removed in 2003 - see http://lkml.org/lkml/2003/1/29/197

Afaik, you always need a bootloader to boot Linux nowadays.

Only exception coming to my mind is booting a UserModeLinux kernel. That one can directly boot from the commandline.

regards
roland



Date Thu, 16 Apr 2009 09:45:14 +0200 
Subject Linux image boot 
>From Dragoslav Zaric <> 

Can you boot linux without GRUB or LILO loader
if it is only OS on your computer ?

I mean does kernel image can boot it-self and if can,
where you should put it ?

thanks

Dragoslav Zaric
[Programmer; M Sc Astrophysics]



______________________________________________________
GRATIS für alle WEB.DE-Nutzer: Die maxdome Movie-FLAT!
Jetzt freischalten unter http://movieflat.web.de

