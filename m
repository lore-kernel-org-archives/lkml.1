Return-Path: <linux-kernel-owner+w=401wt.eu-S1758499AbXFVVam@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758499AbXFVVam (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 17:30:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752425AbXFVVaf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 17:30:35 -0400
Received: from cantor.suse.de ([195.135.220.2]:45972 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752120AbXFVVaf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 17:30:35 -0400
From: Andi Kleen <ak@suse.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH v2] doc/oops-tracing: add Code: decode info
Date: Fri, 22 Jun 2007 23:29:52 +0200
User-Agent: KMail/1.9.1
Cc: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
References: <20070621225108.bb69a93d.randy.dunlap@oracle.com> <200706221923.02736.ak@suse.de> <20070622112503.f1fa10b0.randy.dunlap@oracle.com>
In-Reply-To: <20070622112503.f1fa10b0.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706222329.52255.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Why 3 times?  Why not just (1) everything before marker and
> (2) everything at and after marker?

2 times would probably work too, i was just thinking of a marker around it;
but you're right just before would be also ok.

> > - It won't handle multiline Code:s which i386 likes to generate now I
> > think
>
> I don't see the code in arch/i386/kernel/traps.c generating multiline
> Code:s, just very long single lines.

Yes I must have mislooked.

-Andi
