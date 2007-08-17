Return-Path: <linux-kernel-owner+w=401wt.eu-S1762650AbXHQPxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762650AbXHQPxT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 11:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755116AbXHQPxK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 11:53:10 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3976 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752680AbXHQPxI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 11:53:08 -0400
Subject: Re: [PATCH] [428/2many] MAINTAINERS - SERIAL ATA (SATA) SUBSYSTEM:
From: Joe Perches <joe@perches.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, jgarzik@pobox.com, akpm@linux-foundation.org
In-Reply-To: <46C5C2A1.3020701@ru.mvista.com>
References: <46bffbb6.4FinvGMu+SlIxG24%joe@perches.com>
	 <46C5C2A1.3020701@ru.mvista.com>
Content-Type: text/plain
Date: Fri, 17 Aug 2007 08:52:51 -0700
Message-Id: <1187365972.822.93.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2-2.1mdv2007.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-08-17 at 19:45 +0400, Sergei Shtylyov wrote:

> joe@perches.com wrote:
> > Add file pattern to MAINTAINER entry
> > +F:	drivers/ata/sata_*
>     The libata core doesn't match this pattern, ain't a a vital part of both 
> SAT and PATA drivers?
> MBR, Sergei

Improvements to the pattern would be appreciated.
Would this be a better pattern?

F:	drivers/ata/

There is a SATA-promise maintainer

        PROMISE SATA TX2/TX4 CONTROLLER LIBATA DRIVER
        P:	Mikael Pettersson
        M:	mikpe@it.uu.se
        L:	linux-ide@vger.kernel.org
        S:	Maintained
        F:	drivers/ata/sata_promise.*

maybe there should be an entry to exclude
this maintained driver too?

X:	drivers/ata/sata_promise.*

cheers,  Joe

