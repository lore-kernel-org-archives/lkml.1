Return-Path: <linux-kernel-owner+w=401wt.eu-S933328AbXCTORv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933328AbXCTORv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 10:17:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933439AbXCTORv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 10:17:51 -0400
Received: from rubis.org ([82.230.33.161]:49575 "EHLO rubis.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933328AbXCTORu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 10:17:50 -0400
Message-ID: <45FFECFB.3040003@rubis.org>
Date: Tue, 20 Mar 2007 15:17:31 +0100
From: =?ISO-8859-15?Q?St=E9phane_Jourdois?= <kwisatz@rubis.org>
User-Agent: IceDove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Miles Lane <miles.lane@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21-rc4-mm1 + 3 hot-fixes -- init/.missing_syscalls.h.cmd:2:
 *** missing separator. Stop.
References: <a44ae5cd0703200652q12aa9398if908757174ba1a6@mail.gmail.com>
In-Reply-To: <a44ae5cd0703200652q12aa9398if908757174ba1a6@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Miles Lane a écrit :
> Hello,
> 
> I don't see any announcement for 2.6.21-rc4-mm1 on LKML, but I went
> ahead and tried it out.  I hit the following, even after running
> mrproper.
> 
> init/.missing_syscalls.h.cmd:2: *** missing separator.  Stop.
> make: *** [.tmp_vmlinux1] Error 2

Would you please try the following patch ?

http://lkml.org/lkml/2007/3/20/79

Thanks.

- Stéphane.

-- 
 ///  Stephane Jourdois     /"\  ASCII RIBBON CAMPAIGN \\\
(((    Consultant securite  \ /    AGAINST HTML MAIL    )))
 \\\   24 rue Cauchy         X                         ///
  \\\  75015  Paris         / \    +33 6 8643 3085    ///

-- 
 ///  Stephane Jourdois     /"\  ASCII RIBBON CAMPAIGN \\\
(((    Consultant securite  \ /    AGAINST HTML MAIL    )))
 \\\   24 rue Cauchy         X                         ///
  \\\  75015  Paris         / \    +33 6 8643 3085    ///
