Return-Path: <linux-kernel-owner+w=401wt.eu-S1753491AbXDIVt4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491AbXDIVt4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 17:49:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753415AbXDIVtx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 17:49:53 -0400
Received: from ozlabs.org ([203.10.76.45]:41344 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753308AbXDIVtb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 17:49:31 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17946.34276.305842.461545@cargo.ozlabs.ibm.com>
Date: Tue, 10 Apr 2007 04:28:52 +1000
From: Paul Mackerras <paulus@samba.org>
To: Milind Arun Choudhary <milindchoudhary@gmail.com>
Cc: kernel-janitors@lists.osdl.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, linux-ppp@vger.kernel.org
Subject: Re: [KJ][PATCH]ROUND_UP macro cleanup in drivers/net/ppp_generic.c
In-Reply-To: <20070404174944.GC9830@arun.site>
References: <20070404174944.GC9830@arun.site>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Milind Arun Choudhary writes:

> ROUND_UP macro cleanup use DIV_ROUND_UP
> 
> Signed-off-by: Milind Arun Choudhary <milindchoudhary@gmail.com>

Acked-by: Paul Mackerras <paulus@samba.org>
