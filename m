Return-Path: <linux-kernel-owner+w=401wt.eu-S1759093AbZDAAeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759093AbZDAAeU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 20:34:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751416AbZDAAeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 20:34:09 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:60792 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246AbZDAAeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 20:34:08 -0400
Date: Tue, 31 Mar 2009 20:33:21 -0400
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: linuxppc-dev@ozlabs.org, Andrew Morton <akpm@linux-foundation.org>,
       roel.kluin@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: Add hvc_console to MAINTAINERS
Message-ID: <20090401003321.GA11682@zod.rchland.ibm.com>
References: <49BF956B.9030109@gmail.com> <20090330133531.f5d99c09.akpm@linux-foundation.org> <20090330205553.GA19278@yoda.jdub.homelinux.org> <20090330141852.59baaeda.akpm@linux-foundation.org> <20090331132944.GB2332@yoda.jdub.homelinux.org> <1238543040.6522.10.camel@localhost> <20090331235057.GB563@zod.rchland.ibm.com> <1238544253.6522.14.camel@localhost> <1238545250.6522.17.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1238545250.6522.17.camel@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 01, 2009 at 11:20:50AM +1100, Michael Ellerman wrote:
>Add a MAINTAINERS entry for the hypervisor virtual console driver.
>
>Signed-off-by: Michael Ellerman <michael@ellerman.id.au>

Acked-by: Josh Boyer <jwboyer@linux.vnet.ibm.com>

>---
> MAINTAINERS |    6 ++++++
> 1 files changed, 6 insertions(+), 0 deletions(-)
>
>How about this?
>
>diff --git a/MAINTAINERS b/MAINTAINERS
>index 1c2ca1d..854437a 100644
>--- a/MAINTAINERS
>+++ b/MAINTAINERS
>@@ -1918,6 +1918,12 @@ L:	lm-sensors@lm-sensors.org
> W:	http://www.kernel.org/pub/linux/kernel/people/fseidel/hdaps/
> S:	Maintained
>
>+HYPERVISOR VIRTUAL CONSOLE DRIVER
>+L:	linuxppc-dev@ozlabs.org
>+L:	linux-kernel@vger.kernel.org
>+S:	Odd Fixes
>+F:	drivers/char/hvc_*
>+
> GSPCA FINEPIX SUBDRIVER
> P:	Frank Zago
> M:	frank@zago.net
>-- 
>1.6.1.2
>
>
>
