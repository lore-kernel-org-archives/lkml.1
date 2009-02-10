Return-Path: <linux-kernel-owner+w=401wt.eu-S1754716AbZBJLlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716AbZBJLlS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 06:41:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751202AbZBJLlE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 06:41:04 -0500
Received: from mtagate2.de.ibm.com ([195.212.17.162]:32960 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbZBJLlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 06:41:02 -0500
Subject: Re: [Patch] [s390] Fix init irq proc build break.
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: "Sachin P. Sant" <sachinp@in.ibm.com>
Cc: linux-s390@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       heiko.carstens@de.ibm.com, Mel Gorman <mel@csn.ul.ie>
In-Reply-To: <499161C3.2070407@in.ibm.com>
References: <20090210194121.80256b72.sfr@canb.auug.org.au>
	 <4991573C.8000609@in.ibm.com>  <499161C3.2070407@in.ibm.com>
Content-Type: text/plain
Organization: IBM Corporation
Date: Tue, 10 Feb 2009 12:40:58 +0100
Message-Id: <1234266058.23901.0.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-02-10 at 16:45 +0530, Sachin P. Sant wrote:
> * Embed init_irq_proc(s390) within CONFIG_PROC_FS to fix a build
> break.
> 
> Signed-off-by : Sachin Sant <sachinp@in.ibm.com>

I'll queue the patch to git390.

-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.


