Return-Path: <linux-kernel-owner+w=401wt.eu-S1755757AbYECVR0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755757AbYECVR0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 17:17:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754392AbYECVRN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 17:17:13 -0400
Received: from khc.piap.pl ([195.187.100.11]:56766 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753074AbYECVRM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 17:17:12 -0400
To: Adrian Bunk <bunk@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Ingo, no more kconfig patches
References: <20080430200340.GA13757@elte.hu>
	<20080430170125.ZZRA012@mailhub.coreip.homeip.net>
	<20080430211317.GA24633@elte.hu>
	<20080430230100.GK29330@cs181133002.pp.htv.fi>
	<20080501025234.GE27574@elte.hu>
	<20080501115923.GX29330@cs181133002.pp.htv.fi>
	<20080503191445.GF5292@elte.hu>
	<20080503202416.GR5838@cs181133002.pp.htv.fi>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Sat, 03 May 2008 23:17:09 +0200
In-Reply-To: <20080503202416.GR5838@cs181133002.pp.htv.fi> (Adrian Bunk's message of "Sat\, 3 May 2008 23\:24\:16 +0300")
Message-ID: <m37ieb84ve.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk <bunk@kernel.org> writes:

> I'm not even sure the semantics of "select follows dependencies" 
> would actually be better than what we have today.

I think it would. But how would that actually work? By displaying all
relevant dependency chains and asking the user to select one?
-- 
Krzysztof Halasa
