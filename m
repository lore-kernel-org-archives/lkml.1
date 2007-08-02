Return-Path: <linux-kernel-owner+w=401wt.eu-S1761851AbXHBXaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761851AbXHBXaa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 19:30:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756856AbXHBXaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 19:30:22 -0400
Received: from mail.gmx.net ([213.165.64.20]:54617 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755784AbXHBXaV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 19:30:21 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX18pSw8UWz0p8+T9YVMnLvIVFXqtrGUJEV+zjKqk53
	1FLj3AwV45EiTp
Date: Fri, 3 Aug 2007 01:30:24 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Al Viro <viro@ftp.linux.org.uk>
cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: gcc fixed size char array initialization bug - known?
In-Reply-To: <20070802230914.GT21089@ftp.linux.org.uk>
Message-ID: <Pine.LNX.4.60.0708030128340.6774@poirot.grange>
References: <Pine.LNX.4.60.0708022141420.6774@poirot.grange>
 <p73vebxmysb.fsf@bingen.suse.de> <Pine.LNX.4.60.0708022231160.6774@poirot.grange>
 <46B25B5E.30406@s5r6.in-berlin.de> <Pine.LNX.4.60.0708030046230.6774@poirot.grange>
 <20070802230914.GT21089@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Aug 2007, Al Viro wrote:

> It doesn't change the fact that use of c[4] or strlen(c) or strcpy(..., c)
> means nasal demon country for you.

Haha, funny. You, certainly, may think whatever you want, I'm anyway 
greatful to you and to all the rest for the trouble you took to find THE 
quote that actually answers the question.

Thanks
Guennadi
---
Guennadi Liakhovetski
