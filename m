Return-Path: <linux-kernel-owner+w=401wt.eu-S933510AbXBXP3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933510AbXBXP3c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 10:29:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933512AbXBXP3b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 10:29:31 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:48016 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933510AbXBXP3b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 10:29:31 -0500
Date: Sat, 24 Feb 2007 16:26:10 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Jon Masters <jcm@redhat.com>
cc: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>,
       Sergey Vlasov <vsu@altlinux.ru>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       mit-devel@lists.printk.net
Subject: Re: module-init-tools-3.3-pre10 available
In-Reply-To: <45DF0B42.2080208@redhat.com>
Message-ID: <Pine.LNX.4.61.0702241625030.16527@yvahk01.tjqt.qr>
References: <45DD0031.9010808@redhat.com> <20070222170732.22c1320b.vsu@altlinux.ru>
 <45DDAE24.6080905@redhat.com> <20070223120136.12ea11db@home.brethil>
 <45DF0B42.2080208@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 23 2007 10:41, Jon Masters wrote:
>
> I think it's like the configure/Makefile.in situation. These files should
> technically not be in the repo either (and you removed them in your tree) but I
> re-added them because people have an expectation that:
>
> ./configure
> make
>
> will do something "out of the box".

Out of the box perhaps if it is the .tar.bz2 archive, but the same does not
always hold for CVS repos, much less SVNs [random guess on svn]. He who pulls
from a developer tree mostly knows to run 'autogen.sh' or 'autoreconf -fi'
beforehand.


Jan
-- 
