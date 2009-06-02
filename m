Return-Path: <linux-kernel-owner+w=401wt.eu-S1755336AbZFBNf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336AbZFBNf2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 09:35:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754269AbZFBNfR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 09:35:17 -0400
Received: from one.firstfloor.org ([213.235.205.2]:55150 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754124AbZFBNfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 09:35:16 -0400
Date: Tue, 2 Jun 2009 15:42:25 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "Michael S. Zick" <lkml@morethan.org>
Cc: Andi Kleen <andi@firstfloor.org>, Harald Welte <HaraldWelte@viatech.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: LOCK prefix on uni processor has its use
Message-ID: <20090602134225.GN1065@one.firstfloor.org>
References: <200905221139.26941.lkml@morethan.org> <20090602124854.GB9823@prithivi.gnumonks.org> <20090602130343.GI1065@one.firstfloor.org> <200906020826.09355.lkml@morethan.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906020826.09355.lkml@morethan.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> After another week of chasing this - -

Did you use the "compile part of the kernel with LOCK and others without"
technique I described earlier?

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
