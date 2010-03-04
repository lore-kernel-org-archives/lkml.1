Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893Ab0CDSMB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 13:12:01 -0500
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:34710 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753318Ab0CDSL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 13:11:59 -0500
Date: Thu, 4 Mar 2010 21:11:55 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Sergei Shtylyov <sshtylyov@mvista.com>, Mark Lord <kernel@teksavvy.com>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ahci: Add platform driver
Message-ID: <20100304181155.GA10894@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20100304170525.GA8126@oksana.dev.rtsoft.ru>
 <20100304170606.GB29022@oksana.dev.rtsoft.ru>
 <4B8FF626.6060704@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4B8FF626.6060704@pobox.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 04, 2010 at 01:04:22PM -0500, Jeff Garzik wrote:
> On 03/04/2010 12:06 PM, Anton Vorontsov wrote:
> >This can be used for AHCI-compatible interfaces implemented inside
> >System-On-Chip solutions, or AHCI devices connected via localbus.
> >
> >Signed-off-by: Anton Vorontsov<avorontsov@ru.mvista.com>
> >---
> >  drivers/ata/Kconfig           |    8 ++
> >  drivers/ata/Makefile          |    1 +
> >  drivers/ata/ahci_platform.c   |  191 +++++++++++++++++++++++++++++++++++++++++
> >  include/linux/ahci_platform.h |   29 ++++++
> >  4 files changed, 229 insertions(+), 0 deletions(-)
> >  create mode 100644 drivers/ata/ahci_platform.c
> >  create mode 100644 include/linux/ahci_platform.h
> 
> applied 1-2 to #upstream

Thanks!

> Thanks for this work, this will give me the kick-in-the-pants
> necessary to move forward on mv-ahci and acard-ahci.

:-)

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
