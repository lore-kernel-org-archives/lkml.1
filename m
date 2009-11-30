Return-Path: <linux-kernel-owner+w=401wt.eu-S1753421AbZK3NuO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421AbZK3NuO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 08:50:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752501AbZK3NuO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 08:50:14 -0500
Received: from mail.codesourcery.com ([38.113.113.100]:60604 "EHLO
	mail.codesourcery.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416AbZK3NuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 08:50:13 -0500
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Nov 2009 08:50:13 EST
Message-ID: <4B13CC00.9080607@codesourcery.com>
Date: Mon, 30 Nov 2009 16:43:28 +0300
From: Maxim Kuvyrkov <maxim@codesourcery.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Linux/m68k <linux-m68k@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: M68k tree updates
References: <alpine.DEB.2.00.0911252213340.31650@ayla.of.borg>
In-Reply-To: <alpine.DEB.2.00.0911252213340.31650@ayla.of.borg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven wrote:
> It took me a while, but finally I managed to update
> http://git.kernel.org/?p=linux/kernel/git/geert/linux-m68k.git again.
...
> If anything is missing, please tell me. Thx!

How about the NPTL patch (0001-Add-NPTL-support-for-m68k.patch,
http://marc.info/?l=linux-m68k&m=125447760017098&w=2)?

Also, this trivial fix (0004-Fix-m68k-s-asm-swab.h-for-ColdFire.patch, 
http://marc.info/?l=linux-m68k&m=125447494213740&w=2) can go in.

Thanks!

-- 
Maxim Kuvyrkov
CodeSourcery
maxim@codesourcery.com
(650) 331-3385 x724
