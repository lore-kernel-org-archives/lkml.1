Return-Path: <linux-kernel-owner+w=401wt.eu-S1758952AbXHKIxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758952AbXHKIxQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 04:53:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754805AbXHKIxB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 04:53:01 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:54262 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753683AbXHKIxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 04:53:00 -0400
Subject: Re: 2.6.23-rc2-mm2 build error on MIPS and ARM
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Andrew Morton <akpm@linux-foundation.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070811025802.GA15885@Krystal>
References: <20070811025802.GA15885@Krystal>
Content-Type: text/plain
Organization: IBM Corporation
Date: Sat, 11 Aug 2007 10:56:36 +0200
Message-Id: <1186822596.25775.2.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-08-10 at 22:58 -0400, Mathieu Desnoyers wrote:
> I got the following errors when building 2.6.23-rc2-mm2 on both mips and
> arm. Both errors are very much alike.

Four letter words. Seems like I have install some more cross-compilers
to find all the compile problems with the mm_types move.

-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.


