Return-Path: <linux-kernel-owner+w=401wt.eu-S1762861AbXKTCQd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762861AbXKTCQd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 21:16:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762033AbXKTCKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 21:10:20 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36087
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1762028AbXKTCKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 21:10:17 -0500
Date: Mon, 19 Nov 2007 18:10:16 -0800 (PST)
Message-Id: <20071119.181016.224103721.davem@davemloft.net>
To: clameter@sgi.com
Cc: ak@suse.de, akpm@linux-foundation.org, travis@sgi.com,
       mathieu.desnoyers@polymtl.ca, linux-kernel@vger.kernel.org
Subject: Re: [rfc 00/45] [RFC] CPU ops and a rework of per cpu data
 handling on x86_64
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0711191758390.19954@schroedinger.engr.sgi.com>
References: <20071120011132.143632442@sgi.com>
	<20071119.175116.55102316.davem@davemloft.net>
	<Pine.LNX.4.64.0711191758390.19954@schroedinger.engr.sgi.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Lameter <clameter@sgi.com>
Date: Mon, 19 Nov 2007 17:59:33 -0800 (PST)

> In that case the generic fallbacks can just provide what you already
> have.

I understand, I was just letting you know why we probably won't
take advantage of this new stuff :-)
