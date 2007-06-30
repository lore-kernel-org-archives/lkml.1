Return-Path: <linux-kernel-owner+w=401wt.eu-S1758939AbXF3O2o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758939AbXF3O2o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 10:28:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755688AbXF3O2g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 10:28:36 -0400
Received: from mk-filter-3-a-1.mail.uk.tiscali.com ([212.74.100.54]:53714 "EHLO
	mk-filter-3-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755357AbXF3O2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 10:28:35 -0400
X-SBRS: None
X-RemoteIP: 81.1.80.38
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=DvtM3c9xwEzuotkz3-kA:9 a=HbadMg-CRmC5n2CwFyNF_LKbEt4A:4
X-IronPort-AV: E=Sophos;i="4.16,480,1175468400"; 
   d="scan'208";a="5061438"
Subject: Re: sh section mismatches [was Re: 2.6.22-rc6 on Dreamcast (SH4)]
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: Satyam Sharma <satyam.sharma@gmail.com>
Cc: Mike Frysinger <vapier@gentoo.org>, linuxsh-dev@lists.sourceforge.net,
       LKML <linux-kernel@vger.kernel.org>, Sam Ravnborg <sam@ravnborg.org>
In-Reply-To: <a781481a0706300720p74f08085t55653b007431685f@mail.gmail.com>
References: <a781481a0706280457r4abb5046wc82cff9d49b7975e@mail.gmail.com>
	 <1183210853.6016.2.camel@localhost.localdomain>
	 <a781481a0706300720p74f08085t55653b007431685f@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 30 Jun 2007 15:27:49 +0100
Message-Id: <1183213669.6016.6.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-06-30 at 19:50 +0530, Satyam Sharma wrote:
> Hi,

> Right, as Mike just said, these warnings are the ones from
> drivers/video/pvr2fb.c which the patch didn't touch ... that was only
> to get rid of the "(between 'mv_dreamcast' and 'systemasic_int')"
> warning. But of course, we can't be too sure about the patch till
> you can boot and run the system ...


Boots and runs fine.
