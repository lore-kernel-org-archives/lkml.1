Return-Path: <linux-kernel-owner+w=401wt.eu-S1761864AbXIZVzQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761864AbXIZVzQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 17:55:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754070AbXIZVzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 17:55:04 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:42812 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752352AbXIZVzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 17:55:03 -0400
Date: Wed, 26 Sep 2007 23:55:21 +0200
From: Adrian Bunk <bunk@kernel.org>
To: David Newall <david@davidnewall.com>
Cc: Christer Weinigel <christer@weinigel.se>, Al Viro <viro@ftp.linux.org.uk>,
       Phillip Susi <psusi@cfl.rr.com>, Bill Davidsen <davidsen@tmr.com>,
       majkls <majkls@prepere.com>, linux-kernel@vger.kernel.org
Subject: Re: sys_chroot+sys_fchdir Fix
Message-ID: <20070926215521.GU6800@stusta.de>
References: <46F16A0A.3070402@tmr.com> <20070919194559.36015307@the-village.bc.nu> <46F1A196.8060108@davidnewall.com> <46F401D6.6060609@cfl.rr.com> <20070921191012.15a0b51b@the-village.bc.nu> <46F9752C.5080807@cfl.rr.com> <20070926002340.GL8181@ftp.linux.org.uk> <46FA35A6.1070400@davidnewall.com> <20070926212408.6662231a@zoo.weinigel.se> <46FACCE0.2070005@davidnewall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <46FACCE0.2070005@davidnewall.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2007 at 06:49:28AM +0930, David Newall wrote:
>...
> Look, when chroot was being designed, I think they intended that even root 
> should be unable to get out. They went so far as to say that dot-dot 
> wouldn't let you out; and it doesn't.
>...

You are claiming "They went so far as to say that dot-dot wouldn't let 
you out"?

Who are the "they" people you are referring to?

And where did "they" explicitely state what you claim they did say?

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

