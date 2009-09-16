Return-Path: <linux-kernel-owner+w=401wt.eu-S1759916AbZIPUN5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759916AbZIPUN5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 16:13:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755947AbZIPUN4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 16:13:56 -0400
Received: from mail.perches.com ([173.55.12.10]:1210 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755452AbZIPUN4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 16:13:56 -0400
Subject: Re: [PATCH] MAINTAINERS: Move ARM lists to infradead
From: Joe Perches <joe@perches.com>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-arm-kernel@lists.infradead.org,
       linux-arm-kernel-owner@lists.infradead.org
In-Reply-To: <m3d45qpsgl.fsf@intrepid.localdomain>
References: <1253117388.2567.17.camel@Joe-Laptop.home>
	 <20090916181018.GA19728@Chamillionaire.breakpoint.cc>
	 <1253125008.2567.32.camel@Joe-Laptop.home>
	 <m3d45qpsgl.fsf@intrepid.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Sep 2009 13:13:58 -0700
Message-Id: <1253132038.10465.5.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.27.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-16 at 22:03 +0200, Krzysztof Halasa wrote:
> Joe Perches <joe@perches.com> writes:
> > I believe it's still moderated.
> Does that matter to the point we have to put it in the file?
> Non-spam from non-subscribers passes through, right? The "moderated for
> non-subscribers" suggests that one should subscribe prior to posting,
> which is IMHO not the case.

I don't much care which is selected, but I think it's clear
moderated doesn't mean subscribers-only.

"moderated for non-subscribers" means there might be a
rejection or a delay before a message is forwarded to a list.

Here are the lists that are marked "moderated" in MAINTAINERS

$ grep moderated MAINTAINERS | sort | uniq
L:	alsa-devel@alsa-project.org (moderated for non-subscribers)
L:	bluesmoke-devel@lists.sourceforge.net (moderated for non-subscribers)
L:	linux-am33-list@redhat.com (moderated for non-subscribers)
L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
L:	linux-geode@lists.infradead.org (moderated for non-subscribers)
L:	linux-zigbee-devel@lists.sourceforge.net (moderated for non-subscribers)
L:	ocfs2-devel@oss.oracle.com (moderated for non-subscribers)
L:	rds-devel@oss.oracle.com (moderated for non-subscribers)
L:	tpmdd-devel@lists.sourceforge.net (moderated for non-subscribers)


