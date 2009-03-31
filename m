Return-Path: <linux-kernel-owner+w=401wt.eu-S1763498AbZCaVMr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763498AbZCaVMr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 17:12:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763344AbZCaVLq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 17:11:46 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1867 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763224AbZCaVLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 17:11:45 -0400
Subject: Re: [PATCH] Add hvc_console to MAINTAINERS
From: Joe Perches <joe@perches.com>
To: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linuxppc-dev@ozlabs.org,
       roel.kluin@gmail.com, linux-kernel@vger.kernel.org
In-Reply-To: <20090331132944.GB2332@yoda.jdub.homelinux.org>
References: <49BF956B.9030109@gmail.com>
	 <20090330133531.f5d99c09.akpm@linux-foundation.org>
	 <20090330205553.GA19278@yoda.jdub.homelinux.org>
	 <20090330141852.59baaeda.akpm@linux-foundation.org>
	 <20090331132944.GB2332@yoda.jdub.homelinux.org>
Content-Type: text/plain
Date: Tue, 31 Mar 2009 14:10:23 -0700
Message-Id: <1238533823.9715.292.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2-1.2mdv2009.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-31 at 09:29 -0400, Josh Boyer wrote:
> Add a MAINTAINERS entry for the hypervisor virtual console support
> used on IBM POWER servers.
> 
> Signed-off-by: Josh Boyer <jwboyer@linux.vnet.ibm.com>
> ---
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index c5f4e9d..387ad45 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -2176,6 +2176,11 @@ W:       http://www.ia64-linux.org/
>  T:     git kernel.org:/pub/scm/linux/kernel/git/aegl/linux-2.6.git
>  S:     Maintained
>  
> +IBM HYPERVISOR VIRTUAL CONSOLE
> +P:     Several
> +L:     linuxppc-dev@ozlabs.org
> +S:     Maintained
> +
>  IBM MCA SCSI SUBSYSTEM DRIVER
>  P:     Michael Lang
>  M:     langa2@kph.uni-mainz.de

I think this sort of entry should not be acceptable.
Maintainers should have individual names and contact addresses.

An exploder entry should be OK though.
For instance, the DVB subsystem:

	DVB SUBSYSTEM AND DRIVERS
	P:	LinuxTV.org Project
	M:	linux-media@vger.kernel.org

A list entry could be something like:

	P:	Linux PCMCIA Team
	L:	linux-pcmcia@lists.infradead.org


