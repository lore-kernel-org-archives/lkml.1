Return-Path: <linux-kernel-owner+w=401wt.eu-S1764678AbXHNQTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764678AbXHNQTz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 12:19:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762645AbXHNQTn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 12:19:43 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4629 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762505AbXHNQTm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 12:19:42 -0400
Subject: Re: [PATCH] [153/2many] MAINTAINERS - DEVICE-MAPPER  (LVM)
From: Joe Perches <joe@perches.com>
To: Milan Broz <mbroz@redhat.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       dm-devel@redhat.com, akpm@linux-foundation.org,
       Alasdair G Kergon <agk@redhat.com>
In-Reply-To: <46C1888E.4060501@redhat.com>
References: <46bff986.szARdClTcYqQa8So%joe@perches.com>
	 <46C1888E.4060501@redhat.com>
Content-Type: text/plain
Date: Tue, 14 Aug 2007 09:19:23 -0700
Message-Id: <1187108363.32555.45.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2-2.1mdv2007.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-08-14 at 12:48 +0200, Milan Broz wrote:
> File pattern should be:
> F:	drivers/md/dm*
> F:	drivers/md/kcopyd*
> F:	include/linux/device-mapper.h
> F:	include/linux/dm-ioctl.h
> F:	Documentation/device-mapper/

Thanks.  In my tree I've got:

DEVICE-MAPPER  (LVM)
P:	Alasdair Kergon
L:	dm-devel@redhat.com
W:	http://sources.redhat.com/dm
S:	Maintained
F:      Documentation/device-mapper/
F:      drivers/md/dm*
F:      drivers/md/kcopyd*
F:      include/linux/device-mapper.h
F:      include/linux/dm-ioctl.h


