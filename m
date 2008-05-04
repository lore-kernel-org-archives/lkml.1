Return-Path: <linux-kernel-owner+w=401wt.eu-S1756876AbYEDMSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756876AbYEDMSS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 08:18:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755364AbYEDMSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 08:18:09 -0400
Received: from OSB1387.piap.pl ([195.187.100.11]:52429 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755399AbYEDMSI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 08:18:08 -0400
To: Adrian Bunk <bunk@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Ingo, no more kconfig patches
References: <20080430230100.GK29330@cs181133002.pp.htv.fi>
	<20080501025234.GE27574@elte.hu>
	<20080501115923.GX29330@cs181133002.pp.htv.fi>
	<20080503191445.GF5292@elte.hu>
	<20080503202416.GR5838@cs181133002.pp.htv.fi>
	<m37ieb84ve.fsf@maximus.localdomain>
	<20080503214750.GU5838@cs181133002.pp.htv.fi>
	<m3wsmb6np2.fsf@maximus.localdomain>
	<20080503222943.GX5838@cs181133002.pp.htv.fi>
	<m3r6cj5584.fsf@maximus.localdomain>
	<20080504004943.GC5838@cs181133002.pp.htv.fi>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Sun, 04 May 2008 14:18:06 +0200
In-Reply-To: <20080504004943.GC5838@cs181133002.pp.htv.fi> (Adrian Bunk's message of "Sun\, 4 May 2008 03\:49\:43 +0300")
Message-ID: <m3skwyclfl.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk <bunk@kernel.org> writes:

> Unless I misunderstand your proposal you want to resolve dependencies 
> reversely.
>
> And if you want to only do this for select's: FB_SGIVW could also be 
> select'ed.

Right. Sure, if something selects FB_SGIVW then the user would be
presented a list of dependencies and would have to resolve them to be
allowed to continue.

I think I will have to look at it when the so called free time comes
:-)
-- 
Krzysztof Halasa
