Return-Path: <linux-kernel-owner+w=401wt.eu-S1761877AbXEPBDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761877AbXEPBDS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 21:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760321AbXEPBDL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 21:03:11 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34113
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1758961AbXEPBDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 21:03:10 -0400
Date: Tue, 15 May 2007 18:03:16 -0700 (PDT)
Message-Id: <20070515.180316.41635662.davem@davemloft.net>
To: clameter@sgi.com
Cc: akpm@linux-foundation.org, mroos@linux.ee, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: slab hang on boot
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0705151759420.4399@schroedinger.engr.sgi.com>
References: <20070515172957.02d80d51.akpm@linux-foundation.org>
	<20070515.173820.101498227.davem@davemloft.net>
	<Pine.LNX.4.64.0705151759420.4399@schroedinger.engr.sgi.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Lameter <clameter@sgi.com>
Date: Tue, 15 May 2007 18:00:23 -0700 (PDT)

> Slab allocators: Define common size limitations

Thanks for doing this work Christoph, I'll test this patch out on all
my sparc64 boxes, with both SLAB and SLUB, later this evening.

