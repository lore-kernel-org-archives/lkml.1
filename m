Return-Path: <linux-kernel-owner+w=401wt.eu-S932097AbXCLVaA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932097AbXCLVaA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 17:30:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932244AbXCLVaA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 17:30:00 -0400
Received: from mail0.lsil.com ([147.145.40.20]:58142 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932097AbXCLV37 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 17:29:59 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] MPT FUSION: Delete unused header files.
Date: Mon, 12 Mar 2007 15:29:45 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D70624048@NAMAIL4.ad.lsil.com>
In-Reply-To: <20070312.140025.21595408.davem@davemloft.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] MPT FUSION: Delete unused header files.
Thread-Index: Acdk6Xnd9LjqIhRfTnKwOsrRmZfOowAA8yLQ
From: "Moore, Eric" <Eric.Moore@lsi.com>
To: "David Miller" <davem@davemloft.net>
Cc: <Valdis.Kletnieks@vt.edu>, <rpjday@mindspring.com>,
       <linux-kernel@vger.kernel.org>, <akpm@osdl.org>
X-OriginalArrivalTime: 12 Mar 2007 21:29:46.0396 (UTC) FILETIME=[8E7D6DC0:01C764ED]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> If you're going to include it just for the sake of including it, not
> because the code in question actually uses types or function
> declarations defined in there, don't bother, you're just using an
> anti-social mechanism to keep this header file in the tree.
> 
> Please, let's kill this header file if it is unused.
>

Beside including the header I plan to use every define in that header
defined someplace in the source code.  

Now can I keep the header?

