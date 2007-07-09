Return-Path: <linux-kernel-owner+w=401wt.eu-S1753880AbXGIHYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880AbXGIHYQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 03:24:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751280AbXGIHYB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 03:24:01 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:33899 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbXGIHYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 03:24:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Vlru/L82jHM2eh22r/9lNuMHnVMPJSY+u1e5EOvVgNwZq1Rmem96JjUXYbjJeCFh2wIsMXf3jp4U25YYLhtMZK4W7IPmym/CobmN97yYBVZGZyPPAYNg7R1aLFEm8MAT7KIkixnLm815ObfakMswp0BC9lJJ8vHFMjY3QuBkAbw=
Message-ID: <4691E289.80101@gmail.com>
Date: Mon, 09 Jul 2007 16:23:53 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Rodney Gordon II <meff@spherevision.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [BUG] IT8212 libata driver *still* hard-freezes system on boot
 on	2.6.22 final.
References: <1183944204.8932.8.camel@ghreen.sphere>
In-Reply-To: <1183944204.8932.8.camel@ghreen.sphere>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[cc'ing linux-ide and Bartlomiej.]

Rodney Gordon II wrote:
> Have been quite busy, and I regret I haven't tried a rc kernel in
> awhile, but, this bug has gone un-fixed still.. Thought I'd throw in
> another "heads up"..
> 
> 2.6.22 hang: http://spherevision.org/sync/visual/itelock.jpg
> lspci -vvv: http://spherevision.org/sync/tmp/lspci.out
> 
> Pentium-D 830 3.0GHz Dualcore on a ASUS P5LD2 with latest bios rev.
> 1804.
> 
> SysRq does not work when this locks up.
> 
> Patches, info, things to try, anything is welcome, I am available for
> awhile now and will try anything to get this working.
> 
> Cheers,
> -r
> 


-- 
tejun
