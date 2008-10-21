Return-Path: <linux-kernel-owner+w=401wt.eu-S1753661AbYJUIcM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753661AbYJUIcM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 04:32:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751328AbYJUIb5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 04:31:57 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:4381 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbYJUIb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 04:31:56 -0400
Subject: Re: [PATCH 3/3] MAINTAINERS updates
From: Joe Perches <joe@perches.com>
To: Pavel Machek <pavel@suse.cz>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@osdl-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Uwe Kleine-K?nig <ukleinek@strlen.de>
In-Reply-To: <20081021082623.GD15782@atrey.karlin.mff.cuni.cz>
References: <1224541704-30357-1-git-send-email-joe@perches.com>
	 <1224541704-30357-2-git-send-email-joe@perches.com>
	 <1224541704-30357-3-git-send-email-joe@perches.com>
	 <1224541704-30357-4-git-send-email-joe@perches.com>
	 <20081021082623.GD15782@atrey.karlin.mff.cuni.cz>
Content-Type: text/plain
Date: Tue, 21 Oct 2008 01:31:51 -0700
Message-Id: <1224577912.12101.110.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.0-2mdv2009.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-10-21 at 10:26 +0200, Pavel Machek wrote:
> >  AHA152X SCSI DRIVER
> >  P:	Juergen E. Fischer
> > -M:	Juergen Fischer <fischer@norbit.de>
> > +M:	fischer@norbit.de
> >  L:	linux-scsi@vger.kernel.org
> >  S:	Maintained
> >  F:	drivers/scsi/aha152x*
> >  F:	drivers/scsi/pcmcia/aha152x*
> 
> Actually I like the old style better. It makes copy & paste with mouse
> easy...

I'd prefer a merge of the P and M fields as well,
but didn't want to change that right now.

Consistent use of a single style will allow a script
to merge the fields easily.

cheers, Joe

