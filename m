Return-Path: <linux-kernel-owner+w=401wt.eu-S932838AbXBXQPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932838AbXBXQPb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 11:15:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932839AbXBXQPa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 11:15:30 -0500
Received: from mx1.redhat.com ([66.187.233.31]:56427 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932838AbXBXQPa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 11:15:30 -0500
Message-ID: <45E06439.40403@redhat.com>
Date: Sat, 24 Feb 2007 11:13:45 -0500
From: Jon Masters <jcm@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
CC: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>,
       Sergey Vlasov <vsu@altlinux.ru>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       mit-devel@lists.printk.net
Subject: Re: module-init-tools-3.3-pre10 available
References: <45DD0031.9010808@redhat.com> <20070222170732.22c1320b.vsu@altlinux.ru> <45DDAE24.6080905@redhat.com> <20070223120136.12ea11db@home.brethil> <45DF0B42.2080208@redhat.com> <Pine.LNX.4.61.0702241625030.16527@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0702241625030.16527@yvahk01.tjqt.qr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:

> Out of the box perhaps if it is the .tar.bz2 archive, but the same does not
> always hold for CVS repos, much less SVNs [random guess on svn]. He who pulls
> from a developer tree mostly knows to run 'autogen.sh' or 'autoreconf -fi'
> beforehand.

You know what, you're right of course. Ok, I'm taking those back *out* 
of the repo in the next update and then will have a script generate 
these for the tarball. That does sound like the right thing.

Thanks!

Jon.
