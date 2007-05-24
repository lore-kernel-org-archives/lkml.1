Return-Path: <linux-kernel-owner+w=401wt.eu-S1757583AbXEXL5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757583AbXEXL5j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 07:57:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756044AbXEXL5b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 07:57:31 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:8173 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756039AbXEXL5b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 07:57:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=CruiMbSrtUQtArlo2gaK4AecuYBt/cAA8HFMjhbdm2ORotKkPvQ6xCh/B7ttyGt5gHei3w60Re+6lDm/e6uJJfBFVfOYOEyZNCtuWPU0G25mdvu8ZcdHkeWzugBqeQOFCjF9lSFjW6FBLT0imNl4m2MVGMYHfmtd9pkgl03UwEk=
Date: Thu, 24 May 2007 13:56:33 +0200
From: Diego Calleja <diegocg@gmail.com>
To: "Qi Yong" <qiyong@fc-cn.com>
Cc: "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>,
       "Robert P. J. Day" <rpjday@mindspring.com>,
       "debian developer" <debiandev@gmail.com>, greg@kroah.com,
       linux-kernel@vger.kernel.org,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH - 1/1] Documentation/HOWTO
Message-Id: <20070524135633.53260eb3.diegocg@gmail.com>
In-Reply-To: <2cd57c900705240245s5448257ape203deade7812121@mail.gmail.com>
References: <f24d23310705180629x50c56ayfdcde357f0373fc4@mail.gmail.com>
	<Pine.LNX.4.64.0705181200440.18186@localhost.localdomain>
	<10867.1179509181@turing-police.cc.vt.edu>
	<2cd57c900705240245s5448257ape203deade7812121@mail.gmail.com>
X-Mailer: Sylpheed version 2.3.0beta5 (GTK+ 2.10.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

El Thu, 24 May 2007 17:45:04 +0800, "Qi Yong" <qiyong@fc-cn.com> escribió:

> Hello,
> 
> This duplicated paragraph problem was introduced by the following two
> commits. They are one patch actually.

D'oh, it seems the patch was picked from the mailing list and merged twice,
and I didn't notice it.

> Torvalds, Care to revert one commit?

Agreed, one of them can be removed.


> commit 722385f75efd82d9f480f0765a1e97a4d83cac0d
> Author: Diego Calleja <diegocg@gmail.com>
> Date:   Thu Sep 21 22:37:10 2006 +0200
> 
>     HOWTO: bug report addition
> 
>     I suspect that not many people is subscribed to the bugzilla mailing list,
>     not surprising since the URLs doesn't seem to be in the tree :)
> 
>     After fixing my english, I wonder if the following patch could be applied...
> 
>     Signed-off-by: Diego Calleja <diegocg@gmail.com>
>     Acked-by: Randy Dunlap <rdunlap@xenotime.net>
>     Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> commit 3f27100872b21e4cc70d07b96eeb3611b30bce63
> Author: Diego Calleja <diegocg@gmail.com>
> Date:   Sat Sep 30 23:27:49 2006 -0700
> 
>     [PATCH] HOWTO: mention bughunting
> 
>     Signed-off-by: Diego Calleja <diegocg@gmail.com>
>     Signed-off-by: Andrew Morton <akpm@osdl.org>
>     Signed-off-by: Linus Torvalds <torvalds@osdl.org>
