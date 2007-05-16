Return-Path: <linux-kernel-owner+w=401wt.eu-S932097AbXEPRYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932097AbXEPRYc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 13:24:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757318AbXEPRYZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 13:24:25 -0400
Received: from smtp.cce.hp.com ([161.114.21.22]:3522 "EHLO
	ccerelrim01.cce.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756283AbXEPRYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 13:24:25 -0400
From: "Bob Picco" <bob.picco@hp.com>
Date: Wed, 16 May 2007 13:24:21 -0400
To: Olof Johansson <olof@lixom.net>
Cc: Linas Vepstas <linas@austin.ibm.com>, Bob Picco <bob.picco@hp.com>,
       johnrose@us.ibm.com, linuxppc-dev@ozlabs.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: your mail
Message-ID: <20070516172421.GC25792@localhost>
References: <20070516133046.GB25792@localhost> <20070516164341.GA7008@austin.ibm.com> <20070516171100.GA25056@lixom.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070516171100.GA25056@lixom.net>
User-Agent: Mutt/1.5.11
X-PMX-Version: 5.3.1.294258, Antispam-Engine: 2.5.1.298604, Antispam-Data: 2007.5.16.101035
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Olof Johansson wrote:	[Wed May 16 2007, 01:11:00PM EDT]
> On Wed, May 16, 2007 at 11:43:41AM -0500, Linas Vepstas wrote:
> > On Wed, May 16, 2007 at 09:30:46AM -0400, Bob Picco wrote:
> > > Subject: Re: 2.6.22-rc1-mm1 powerpc build breakage
> > > 
> > > /usr/src/linux-2.6.22-rc1-mm1/drivers/pci/hotplug/rpadlpar_sysfs.c:132: error: unknown field `subsys' specified in initializer
> > > /usr/src/linux-2.6.22-rc1-mm1/drivers/pci/hotplug/rpadlpar_sysfs.c:132: warning: initialization from incompatible pointer type
> > > make[4]: *** [drivers/pci/hotplug/rpadlpar_sysfs.o] Error 1
> > > make[3]: *** [drivers/pci/hotplug] Error 2
> > > make[2]: *** [drivers/pci] Error 2
> > > make[1]: *** [drivers] Error 2
> > > make: *** [_all] Error 2
> > 
> > John Rose is working to fix this "real soon now".
> 
> Do you mean the fix Al Viro posted yesterday?
> 
> http://patchwork.ozlabs.org/linuxppc/patch?id=11177
> 
> 
> -Olof
Missed that patch.

thanks,

bob
