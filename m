Return-Path: <linux-kernel-owner+w=401wt.eu-S1761441AbXKHQB0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761441AbXKHQB0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 11:01:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758744AbXKHQBP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 11:01:15 -0500
Received: from palrel10.hp.com ([156.153.255.245]:34190 "EHLO palrel10.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757570AbXKHQBO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 11:01:14 -0500
Subject: Plans for Onezonelist patch series ???
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Christoph Lameter <clameter@sgi.com>, akpm@linux-foundatin.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <1194535612.6214.9.camel@localhost>
References: <20071107011130.382244340@sgi.com>
	 <1194535612.6214.9.camel@localhost>
Content-Type: text/plain
Organization: HP/OSLO
Date: Thu, 08 Nov 2007 11:01:14 -0500
Message-Id: <1194537674.5295.8.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mel [anyone?]

Do you know what the plans are for your "onezonelist" patch series?

Are they going into -mm for, maybe, .25?  Or have they been dropped.  

I carry the last posting in my mempolicy tree--sometimes below my
patches; sometimes above.  Our patches touch some of the same places in
mempolicy.c and require reject resolution when changing the order.  I
can save Andrew some work if I knew that your patches were going to be
in the next -mm by holding off and doing the rebase myself.

Regards,
Lee

