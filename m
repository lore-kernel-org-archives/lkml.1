Return-Path: <linux-kernel-owner+w=401wt.eu-S2993074AbXDTNNP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993074AbXDTNNP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 09:13:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993070AbXDTNNP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 09:13:15 -0400
Received: from mtagate1.uk.ibm.com ([195.212.29.134]:49955 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993034AbXDTNNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 09:13:14 -0400
Subject: Re: [S390] add arch_trampoline_kprobe.
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: ananth@in.ibm.com
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       akpm@linux-foundation.org, srinivasa@in.ibm.com
In-Reply-To: <20070420130908.GA17273@in.ibm.com>
References: <20070420110842.GA17147@skybase>
	 <20070420130908.GA17273@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Organization: IBM Corporation
Date: Fri, 20 Apr 2007 15:13:27 +0200
Message-Id: <1177074807.28747.4.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-04-20 at 18:39 +0530, Ananth N Mavinakayanahalli wrote:
> Cornelia provided this patch sometime earlier
> (http://marc.info/?l=linux-kernel&m=117620748921086&w=2). Andrew has
> picked it up into -mm.

Ok, good. The latest version of -mm on kernel.org did not have it yet.

-- 
blue skies,              IBM Deutschland Entwicklung GmbH
   Martin                Vorsitzender des Aufsichtsrats: Johann Weihen
                         Geschäftsführung: Herbert Kircher
Martin Schwidefsky       Sitz der Gesellschaft: Böblingen
Linux on zSeries         Registergericht: Amtsgericht Stuttgart,
   Development           HRB 243294

"Reality continues to ruin my life." - Calvin.


