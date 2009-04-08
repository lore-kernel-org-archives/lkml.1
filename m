Return-Path: <linux-kernel-owner+w=401wt.eu-S1764289AbZDHKrd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764289AbZDHKrd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 06:47:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755348AbZDHKqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 06:46:33 -0400
Received: from mailgate6.9netweb.it ([66.71.190.69]:47669 "EHLO
	mailgate6.9netweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764248AbZDHKqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 06:46:32 -0400
Message-ID: <49DC8061.9060803@evidence.eu.com>
Date: Wed, 08 Apr 2009 12:45:53 +0200
From: Claudio Scordino <claudio@evidence.eu.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Mikael Starvik <mikael.starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Hinko Kocevar <hinko.kocevar@cetrtapot.si>,
       Janez Cufer <janez.cufer@cetrtapot.si>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       dev-etrax <dev-etrax@axis.com>,
       "adobriyan@gmail.com" <adobriyan@gmail.com>
Subject: Re: [PATCH] Fix broken compilation of Cris serial driver
References: <49DC7754.4030404@evidence.eu.com> <4BEA3FF3CAA35E408EA55C7BE2E61D053B06F59AF3@xmail3.se.axis.com>
In-Reply-To: <4BEA3FF3CAA35E408EA55C7BE2E61D053B06F59AF3@xmail3.se.axis.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikael Starvik ha scritto:
> Looks ok, go ahead and commit!

Please, give me more information about to do that: I was expecting 
that you would merge it in your own tree.

The merge window has been closed but I suppose it does not apply to 
this patch since at the moment the driver does not even compile. So we 
should fix it before 2.6.30.

Should I send the patch to some specific maintainer ?

Will someone see the patch posted to LKML and will merge it ?

Will Alan take over this patch as he did for my previous one ?

Many thanks,

          Claudio
