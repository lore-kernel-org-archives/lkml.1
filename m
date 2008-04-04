Return-Path: <linux-kernel-owner+w=401wt.eu-S1759032AbYDDRqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759032AbYDDRqR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 13:46:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756728AbYDDRqD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 13:46:03 -0400
Received: from nn7.de ([85.214.94.156]:40571 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756715AbYDDRqB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 13:46:01 -0400
Subject: RE: 2.6.25-current-git hangs on boot unless CONFIG_CPU_IDLE=n-Apple
From: Soeren Sonnenburg <kernel@nn7.de>
To: "Pallipadi\, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: "Carlos R\. Mafra" <crmafra2@gmail.com>, Ray Lee <ray-lk@madrabbit.org>,
       "Rafael J\. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <924EFEDD5F540B4284297C4DC59F3DEED0ECFE@orsmsx423.amr.corp.intel.com>
References: <pdj7pZVURbL.A.42H.kDW9HB@albercik>
	 <pdYe6zNQVl.A.AOB.6GW9HB@albercik>
	 <924EFEDD5F540B4284297C4DC59F3DEED0EA1E@orsmsx423.amr.corp.intel.com>
	 <20080404011053.GA21254@localhost.ift.unesp.br>
	 <2c0942db0804032015y57e91811r37b729cd836cef6d@mail.gmail.com>
	 <20080404114756.GA3890@localhost.ift.unesp.br>
	 <924EFEDD5F540B4284297C4DC59F3DEED0EB77@orsmsx423.amr.corp.intel.com>
	 <20080404155155.GA6578@localhost.ift.unesp.br>
	 <924EFEDD5F540B4284297C4DC59F3DEED0ECFE@orsmsx423.amr.corp.intel.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 04 Apr 2008 19:42:19 +0200
Message-Id: <1207330939.5027.2.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-04-04 at 10:37 -0700, Pallipadi, Venkatesh wrote:
[...]
> >> Can you try the latest git and see whether this still is a problem?
> >
> >I've just updated to latest git, but it may take some time for it 
> >to happen again (the first 3 boots were okay). Last time it happened
> >with 2.6.25-rc7-00149-gaf8be4e (I checked now). 
> >
> >Do you have reasons to believe this issue was fixed since then?
> 
> Yes. I think the patch here should have fixed the problem....
> Patch : http://marc.info/?l=linux-kernel&m=120674502201007&w=4

But this patch is not in the current mainstream... (yet?)
Soeren

