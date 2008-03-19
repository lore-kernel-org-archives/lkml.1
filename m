Return-Path: <linux-kernel-owner+w=401wt.eu-S1758770AbYCSWmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758770AbYCSWmu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 18:42:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755568AbYCSVMb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 17:12:31 -0400
Received: from eth7959.sa.adsl.internode.on.net ([150.101.82.22]:32943 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764835AbYCSVMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 17:12:30 -0400
Message-ID: <47E12227.50404@davidnewall.com>
Date: Thu, 20 Mar 2008 00:54:39 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Gene Heskett <gene.heskett@gmail.com>
CC: Willy Tarreau <w@1wt.eu>, Greg KH <greg@kroah.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] 2.4: Back-port of pl2303.c from 2.6.24.1
References: <479A83DE.8020002@davidnewall.com> <47BE267E.3070508@davidnewall.com> <20080222100223.GA4711@1wt.eu> <200802221247.48178.gene.heskett@gmail.com>
In-Reply-To: <200802221247.48178.gene.heskett@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gene,

Gene Heskett wrote:
> I was not successfull at testing [pl2303 on kernel 2.4] last night, even
> locally built versions of roadnav are segfaulting for me now.  Something
> still missing from the wxGTK camp I believe.

Have you any new results testing the back-ported pl2303 driver?

Regards,

David
