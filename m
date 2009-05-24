Return-Path: <linux-kernel-owner+w=401wt.eu-S1751604AbZEXGOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751604AbZEXGOR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 02:14:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751120AbZEXGOE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 02:14:04 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:50479 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020AbZEXGOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 02:14:03 -0400
Date: Sat, 23 May 2009 23:13:57 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ieee1394: eth1394: use "firewire%d" instead of "eth%d"
 as interface name
In-Reply-To: <4A1565B6.10907@s5r6.in-berlin.de>
Message-ID: <alpine.DEB.2.01.0905232309400.7424@bogon>
References: <tkrat.21c425cc195510c9@s5r6.in-berlin.de> <20090521134856.GA3457@psychotron.englab.brq.redhat.com> <4A1565B6.10907@s5r6.in-berlin.de>
User-Agent: Alpine 2.01 (DEB 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX1/hMCjdWC6fpJbYBRctn0dA1GyQTEhvXLhssy7
 FeEZOFLxefJekP9kWWk5Ir+skTRx3cJyu6TVZ3xa8aG7of8RG6
 Di63OguVE/E74+ijkMC/w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 May 2009, Stefan Richter wrote:
> BTW, FreeBSD uses the name fwip%d AFAIK, and OS X just uses fw%d.  (But

If the patch will be accepted at all and it's not too late to ask: I'd 
vote for fw%d as well, "firefire" just looks too long, for me at least. 
And hey, if Apple can do it...we can too :-)   *duck*

Christian.
-- 
Bruce Schneier stole my bike.
