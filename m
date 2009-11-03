Return-Path: <linux-kernel-owner+w=401wt.eu-S1754524AbZKCT0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524AbZKCT0p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 14:26:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753973AbZKCT0o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 14:26:44 -0500
Received: from qmta11.westchester.pa.mail.comcast.net ([76.96.59.211]:45330
	"EHLO QMTA11.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752566AbZKCT0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 14:26:44 -0500
X-Greylist: delayed 349 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Nov 2009 14:26:43 EST
Message-Id: <200911031920.nA3JKtDK019183@deneb.dwf.com>
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.1
To: Valdis.Kletnieks@vt.edu
cc: Reg Clemens <reg@dwf.com>, linux-kernel@vger.kernel.org, reg@fw.dwf.com
Subject: Re: Can build 2.6.31.5 on one P4 but not another. 
In-reply-to: <8575.1257273906@turing-police.cc.vt.edu> 
References: <200911031815.nA3IFCe6017661@deneb.dwf.com> 
 <8575.1257273906@turing-police.cc.vt.edu>
Comments: In-reply-to Valdis.Kletnieks@vt.edu
   message dated "Tue, 03 Nov 2009 13:45:06 -0500."
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Tue, 03 Nov 2009 12:20:55 -0700
From: Reg Clemens <reg@dwf.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 03 Nov 2009 11:15:12 MST, Reg Clemens said:
> > Can someone explain this to me.
> 
> > I dont understand how this can build on one P4 and not another.
> 
> Different .configs?  gcc?  binutils?  Those are the first 3 that come to mind...

Same config files (I should have mentioned this)
Different gcc's
And I would assume that the loader is the only binutil involved

-- 
                                        Reg.Clemens
                                        reg@dwf.com


