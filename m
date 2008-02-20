Return-Path: <linux-kernel-owner+w=401wt.eu-S933078AbYBTQ6o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933078AbYBTQ6o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 11:58:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755522AbYBTQ6b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 11:58:31 -0500
Received: from one.firstfloor.org ([213.235.205.2]:59792 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755603AbYBTQ63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 11:58:29 -0500
Message-ID: <47BC5C99.3010008@firstfloor.org>
Date: Wed, 20 Feb 2008 18:00:09 +0100
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: balbir@linux.vnet.ibm.com
CC: John Stoffel <john@stoffel.org>, Jan Engelhardt <jengelh@computergmbh.de>,
       akpm@osdl.org, torvalds@osdl.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH] Document huge memory/cache overhead of memory controller
 in Kconfig
References: <20080220122338.GA4352@basil.nowhere.org> <47BC2275.4060900@linux.vnet.ibm.com> <18364.16552.455371.242369@stoffel.org> <47BC4554.10304@linux.vnet.ibm.com> <Pine.LNX.4.64.0802201647060.26109@fbirervta.pbzchgretzou.qr> <18364.20755.798295.881259@stoffel.org> <47BC5211.6030102@linux.vnet.ibm.com>
In-Reply-To: <47BC5211.6030102@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> OK, I'll queue a patch and try to explain various terms used by resource management.

Don't make it too verbose or nobody will read it. It should
be more like a one paragraph abstract on a scientific paper
about the linux memory controller.

But I think it should include some variant of the warning that
was in the original patch in this thread (that could be the
second paragraph)

-Andi
