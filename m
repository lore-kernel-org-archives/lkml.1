Return-Path: <linux-kernel-owner+w=401wt.eu-S1754464AbZKBLdP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464AbZKBLdP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 06:33:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754301AbZKBLdO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 06:33:14 -0500
Received: from proxy.DResearch.DE ([87.193.137.100]:37331 "EHLO
	mail.dresearch.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754134AbZKBLdN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 06:33:13 -0500
X-Greylist: delayed 1197 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Nov 2009 06:33:13 EST
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: Patch: Fix userland build failure in linux/if_tunnel.h
Date: Mon, 2 Nov 2009 12:15:38 +0100
Message-ID: <69E6C70090A0A14498CC98FAE5E06B6E3CFA6B@hiob.intern.dresearch.de>
In-Reply-To: <20091102135750.436a7b54@emcraft.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Patch: Fix userland build failure in linux/if_tunnel.h
Thread-Index: AcpbrWgq24k6l2bUQ+e8NTQ1z6Jceg==
References: <4AEDCBA6.7040206@dresearch.de> <20091102135750.436a7b54@emcraft.com>
From: "Sledz, Steffen" <sledz@DResearch.DE>
To: "Sergei Poselenov" <sposelenov@emcraft.com>
Cc: <wd@denx.de>, <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Sergei, hello other maintainers,

> > i'm working for the OpenEmbedded project and we hit the same busybox
> > problem you mentioned in <http://patchwork.kernel.org/patch/31164/>.
> > 
> > It doesn't look like you got much feedback on you patch suggestion.
> > Did it made it's way to the kernel sources? Or where there any
> > objections on it?

> Hm, I received a confirmation, that my fix was applied
> http://www.spinics.net/lists/netdev/msg103860.html

No, i think it didn't. This confirmation is related to a patch from
Joe Perches to the MAINTAINERS file.

> However, it indeed didn't find their way into the mainline.
> I have no idea why, received no objections.

What are the maintainers saying?

Steffen

