Return-Path: <linux-kernel-owner+w=401wt.eu-S935030AbXEIDwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935030AbXEIDwa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 23:52:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967367AbXEIDwW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 23:52:22 -0400
Received: from gate.crashing.org ([63.228.1.57]:42865 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753978AbXEIDwV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 23:52:21 -0400
Subject: Re: Remove an unused variable from get_unmapped_area()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: David Gibson <david@gibson.dropbear.id.au>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20070509032811.GI4198@localhost.localdomain>
References: <20070509032811.GI4198@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 09 May 2007 13:52:07 +1000
Message-Id: <1178682727.14928.145.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-05-09 at 13:28 +1000, David Gibson wrote:
> Some recent changes in get_unmapped_area() have left the 'ret'
> local unused.  This patch removes it.
> 
> Signed-off-by: David Gibson <dwg@au1.ibm.com>

Yeah, my fault, though somebody already posted a patch for this 

Ben.


