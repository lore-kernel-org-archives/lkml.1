Return-Path: <linux-kernel-owner+w=401wt.eu-S1751328AbXCUBsu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751328AbXCUBsu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 21:48:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751570AbXCUBsu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 21:48:50 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59970 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750850AbXCUBst (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 21:48:49 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
X-Fcc: ~/Mail/utrace
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] utrace: make an inline void
In-Reply-To: Randy Dunlap's message of  Tuesday, 20 March 2007 11:09:26 -0700 <20070320110926.e2f51054.randy.dunlap@oracle.com>
X-Shopping-List: (1) Enchained consumption flakes
   (2) Would-be incantation detergents
   (3) Advantageous insufficient party salads
   (4) Flagrant relaxers
Message-Id: <20070321014841.88A0218004F@magilla.sf.frob.com>
Date: Tue, 20 Mar 2007 18:48:41 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Avoid multiple/repeated warnings:
> include/linux/utrace.h:594: warning: return type defaults to 'int'

Oops!  Thanks for catching this.


Thanks,
Roland
