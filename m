Return-Path: <linux-kernel-owner+w=401wt.eu-S933794AbYAaNAr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933794AbYAaNAr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 08:00:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933202AbYAaNAb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 08:00:31 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:60366 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932830AbYAaNAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 08:00:30 -0500
Subject: Re: High wake up latencies with FAIR_USER_SCHED
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Guillaume Chazarain <guichaz@yahoo.fr>
Cc: vatsa@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, dhaval@linux.vnet.ibm.com
In-Reply-To: <3d8471ca0801310449y426742b8yf711c7859b105469@mail.gmail.com>
References: <3d8471ca0801271201o5a41955cg552ef06a2f821285@mail.gmail.com>
	 <20080128023129.GD1044@linux.vnet.ibm.com>
	 <3d8471ca0801280857m2ea8518ds2ad8d5346f756a0e@mail.gmail.com>
	 <3d8471ca0801281213l5ec62984i763afb22216cb423@mail.gmail.com>
	 <1201776461.28547.289.camel@lappy>
	 <3d8471ca0801310449y426742b8yf711c7859b105469@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 31 Jan 2008 14:00:23 +0100
Message-Id: <1201784423.28547.302.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-01-31 at 13:49 +0100, Guillaume Chazarain wrote:
> On 1/31/08, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > Does something like this help?
> 
> I made it compile by open coding undefined macros instead of
> refactoring the whole file.
> But it didn't affect wake up latencies.

Ah, well, what can one expect from mid-night ideas :-)

Thanks for testing!

