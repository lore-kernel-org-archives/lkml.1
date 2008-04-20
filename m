Return-Path: <linux-kernel-owner+w=401wt.eu-S1758904AbYDTUKW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758904AbYDTUKW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 16:10:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756561AbYDTUKJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 16:10:09 -0400
Received: from one.firstfloor.org ([213.235.205.2]:60100 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756359AbYDTUKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 16:10:08 -0400
Message-ID: <480BA2E3.6030703@firstfloor.org>
Date: Sun, 20 Apr 2008 22:09:07 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@logfs.org>, Willy Tarreau <w@1wt.eu>,
       Mark Lord <lkml@rtr.ca>, Adrian Bunk <bunk@kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Shawn Bohrer <shawn.bohrer@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86: 4kstacks default
References: <20080420085104.GG1595@cs181133002.pp.htv.fi>	<20080420103611.2c0d3519@the-village.bc.nu>	<20080420104444.GI1595@cs181133002.pp.htv.fi>	<87y778aezh.fsf@basil.nowhere.org>	<20080420124717.GH8474@1wt.eu>	<480B44C4.4060104@rtr.ca>	<20080420133857.GB26536@1wt.eu>	<480B50F1.8040309@firstfloor.org>	<20080420164133.GB20694@logfs.org>	<480B7B1E.7010707@firstfloor.org>	<20080420174249.GC20694@logfs.org>	<480B8932.1090308@firstfloor.org> <20080420115053.7151ef8d@laptopd505.fenrus.org>
In-Reply-To: <20080420115053.7151ef8d@laptopd505.fenrus.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:

> this is what Al did for the symlink recursion thing, 

AFAIK most symlink lookups are still recursive.

-Andi
