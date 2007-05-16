Return-Path: <linux-kernel-owner+w=401wt.eu-S1762726AbXEPQoK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762726AbXEPQoK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 12:44:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760008AbXEPQny
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 12:43:54 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:48646 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761473AbXEPQnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 12:43:53 -0400
Date: Wed, 16 May 2007 11:43:41 -0500
To: Bob Picco <bob.picco@hp.com>, johnrose@us.ibm.com
Cc: Andrew Morton <akpm@linux-foundation.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: your mail
Message-ID: <20070516164341.GA7008@austin.ibm.com>
References: <20070516133046.GB25792@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070516133046.GB25792@localhost>
User-Agent: Mutt/1.5.11
From: linas@austin.ibm.com (Linas Vepstas)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2007 at 09:30:46AM -0400, Bob Picco wrote:
> Subject: Re: 2.6.22-rc1-mm1 powerpc build breakage
> 
> /usr/src/linux-2.6.22-rc1-mm1/drivers/pci/hotplug/rpadlpar_sysfs.c:132: error: unknown field `subsys' specified in initializer
> /usr/src/linux-2.6.22-rc1-mm1/drivers/pci/hotplug/rpadlpar_sysfs.c:132: warning: initialization from incompatible pointer type
> make[4]: *** [drivers/pci/hotplug/rpadlpar_sysfs.o] Error 1
> make[3]: *** [drivers/pci/hotplug] Error 2
> make[2]: *** [drivers/pci] Error 2
> make[1]: *** [drivers] Error 2
> make: *** [_all] Error 2

John Rose is working to fix this "real soon now".

--linas
