Return-Path: <linux-kernel-owner+w=401wt.eu-S1762593AbXEPRHu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762593AbXEPRHu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 13:07:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756943AbXEPRHn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 13:07:43 -0400
Received: from lixom.net ([66.141.50.11]:39146 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755222AbXEPRHm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 13:07:42 -0400
Date: Wed, 16 May 2007 12:11:00 -0500
To: Linas Vepstas <linas@austin.ibm.com>
Cc: Bob Picco <bob.picco@hp.com>, johnrose@us.ibm.com, linuxppc-dev@ozlabs.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: your mail
Message-ID: <20070516171100.GA25056@lixom.net>
References: <20070516133046.GB25792@localhost> <20070516164341.GA7008@austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070516164341.GA7008@austin.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: olof@lixom.net (Olof Johansson)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2007 at 11:43:41AM -0500, Linas Vepstas wrote:
> On Wed, May 16, 2007 at 09:30:46AM -0400, Bob Picco wrote:
> > Subject: Re: 2.6.22-rc1-mm1 powerpc build breakage
> > 
> > /usr/src/linux-2.6.22-rc1-mm1/drivers/pci/hotplug/rpadlpar_sysfs.c:132: error: unknown field `subsys' specified in initializer
> > /usr/src/linux-2.6.22-rc1-mm1/drivers/pci/hotplug/rpadlpar_sysfs.c:132: warning: initialization from incompatible pointer type
> > make[4]: *** [drivers/pci/hotplug/rpadlpar_sysfs.o] Error 1
> > make[3]: *** [drivers/pci/hotplug] Error 2
> > make[2]: *** [drivers/pci] Error 2
> > make[1]: *** [drivers] Error 2
> > make: *** [_all] Error 2
> 
> John Rose is working to fix this "real soon now".

Do you mean the fix Al Viro posted yesterday?

http://patchwork.ozlabs.org/linuxppc/patch?id=11177


-Olof
