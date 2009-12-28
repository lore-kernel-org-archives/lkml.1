Return-Path: <linux-kernel-owner+w=401wt.eu-S1751848AbZL1O4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751848AbZL1O4W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 09:56:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751686AbZL1O4V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 09:56:21 -0500
Received: from one.firstfloor.org ([213.235.205.2]:56956 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbZL1O4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 09:56:20 -0500
Date: Mon, 28 Dec 2009 15:56:19 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Stefani Seibold <stefani@seibold.net>
Cc: Andi Kleen <andi@firstfloor.org>, Roland Dreier <rdreier@cisco.com>,
       linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: Re: [PATCH] [0/6] kfifo fixes/improvements
Message-ID: <20091228145619.GC4994@basil.fritz.box>
References: <200912271003.631128760@firstfloor.org> <1261949800.25298.18.camel@wall-e> <adahbrcyn1l.fsf@roland-alpha.cisco.com> <20091228014141.GE2399@basil.fritz.box> <1261983994.31031.18.camel@wall-e>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1261983994.31031.18.camel@wall-e>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I guess the reimplementation came too late (happens sometimes)
> > And I agree that making kfifos record oriented makes sense.
> 
> What does it mean? To late for 2.6.33 or to late to replace it for ever?

For 2.6.33 it's too late. Perhaps 2.6.34.

For 2.6.33 we just have to fix what's in. That is why I think
my patches are needed.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
