Return-Path: <linux-kernel-owner+w=401wt.eu-S1754352AbZKWBuY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754352AbZKWBuY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 20:50:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754012AbZKWBuX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 20:50:23 -0500
Received: from ozlabs.org ([203.10.76.45]:43536 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753827AbZKWBuX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 20:50:23 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Subject: Re: [PATCH] kernel.h: Fix kernel-doc notation
Date: Mon, 23 Nov 2009 12:20:26 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; i686; ; )
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       LKML <linux-kernel@vger.kernel.org>, trivial@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
References: <1258877529.4495.43.camel@ht.satnam>
In-Reply-To: <1258877529.4495.43.camel@ht.satnam>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200911231220.26402.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Nov 2009 06:42:09 pm Jaswinder Singh Rajput wrote:
> 
> Fix the following htmldocs warnings:
> 
>   Warning(include/linux/kernel.h:708): No description found for parameter 'condition'
>   Warning(include/linux/kernel.h:708): Excess function parameter 'cond' description in 'BUILD_BUG_ON'

This look like  ajob for trivial@kernel.org or akpm?

For the pedants: Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Thanks!
Rusty.
