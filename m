Return-Path: <linux-kernel-owner+w=401wt.eu-S934059AbXCTULu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934059AbXCTULu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 16:11:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934056AbXCTULu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 16:11:50 -0400
Received: from perninha.conectiva.com.br ([200.140.247.100]:47740 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934051AbXCTULt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 16:11:49 -0400
Date: Tue, 20 Mar 2007 17:11:14 -0300
From: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
To: Sergey Vlasov <vsu@altlinux.ru>
Cc: Jon Masters <jcm@redhat.com>, Jan Engelhardt <jengelh@linux01.gwdg.de>,
       mit-devel@lists.printk.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [mit-devel] Re: module-init-tools-3.3-pre10 available
Message-ID: <20070320171114.60f09fc0@localhost>
In-Reply-To: <20070320200345.GB4021@procyon.home>
References: <45DD0031.9010808@redhat.com>
	<20070222170732.22c1320b.vsu@altlinux.ru>
	<45DDAE24.6080905@redhat.com>
	<20070223120136.12ea11db@home.brethil>
	<45DF0B42.2080208@redhat.com>
	<Pine.LNX.4.61.0702241625030.16527@yvahk01.tjqt.qr>
	<45E06439.40403@redhat.com>
	<20070320200345.GB4021@procyon.home>
Organization: Mandriva
X-Mailer: Sylpheed-Claws 2.5.0-rc3 (GTK+ 2.10.3; i586-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, 20 Mar 2007 23:03:45 +0300
Sergey Vlasov <vsu@altlinux.ru> escreveu:

| On Sat, Feb 24, 2007 at 11:13:45AM -0500, Jon Masters wrote:
| > Jan Engelhardt wrote:
| > 
| > >Out of the box perhaps if it is the .tar.bz2 archive, but the same does not
| > >always hold for CVS repos, much less SVNs [random guess on svn]. He who 
| > >pulls
| > >from a developer tree mostly knows to run 'autogen.sh' or 'autoreconf -fi'
| > >beforehand.
| > 
| > You know what, you're right of course. Ok, I'm taking those back *out* 
| > of the repo in the next update and then will have a script generate 
| > these for the tarball. That does sound like the right thing.
| 
| Has a final decision about generated files been made?  I don't see any
| updates in the git repo, and man pages are still broken (any attempt
| to regenerate them will cause changes to the generated files to be
| lost).

 I've asked Jon to drop the manpage patches, I won't work on m-i-t
tools anytime soon.

-- 
Luiz Fernando N. Capitulino
