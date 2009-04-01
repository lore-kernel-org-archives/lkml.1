Return-Path: <linux-kernel-owner+w=401wt.eu-S1759582AbZDAGtP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759582AbZDAGtP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 02:49:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758605AbZDAGs6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 02:48:58 -0400
Received: from smtp.nokia.com ([192.100.122.230]:36606 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758588AbZDAGs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 02:48:57 -0400
Subject: Re: [patch/rfc 2.6.29 2/2] MTD: support driver model updates
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: David Brownell <david-b@pacbell.net>
Cc: Linux MTD <linux-mtd@lists.infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, Kay Sievers <kay.sievers@vrfy.org>
In-Reply-To: <200903312342.24019.david-b@pacbell.net>
References: <200903260039.34013.david-b@pacbell.net>
	 <200903312257.37434.david-b@pacbell.net>
	 <1238566203.20906.31.camel@localhost.localdomain>
	 <200903312342.24019.david-b@pacbell.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Apr 2009 09:48:08 +0300
Message-Id: <1238568488.20906.34.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 01 Apr 2009 06:48:10.0237 (UTC) FILETIME=[D2265AD0:01C9B295]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-31 at 23:42 -0700, David Brownell wrote:
> On Tuesday 31 March 2009, Artem Bityutskiy wrote:
> > OK. MTD long needs sysfs, and I'm very happy with this
> > patches, even though they are not 100% complete. Good
> > start anyway.
> > 
> > Acked-by: Artem Bityutskiy <dedekind@infradead.org>
> 
> Thanks.  I'll expect someone to handle getting these
> merged through the MTD tree, then.

David Woodhouse maintains the MTD tree. He saw your patches,
not sure when he takes them.

> And I'll be rather surprised if no more attributes
> appear by the time this gets to mainline!  :)

If he merges them during this merge window, then this might
not be the case :-)

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

