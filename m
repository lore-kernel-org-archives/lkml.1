Return-Path: <linux-kernel-owner+w=401wt.eu-S1761500AbYFDVT4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761500AbYFDVT4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 17:19:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754493AbYFDVTs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 17:19:48 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:6836 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231AbYFDVTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 17:19:47 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5310"; a="3684852"
Message-ID: <48470708.5030303@qualcomm.com>
Date: Wed, 04 Jun 2008 14:20:08 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Paul Jackson <pj@sgi.com>
CC: andi@firstfloor.org, ioe-lkml@rameria.de, sivanich@sgi.com,
       a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       kernel@kolivas.org, dfults@sgi.com, devik@cdi.cz, dino@in.ibm.com,
       emmanuel.pacaud@univ-poitiers.fr, deweerdt@free.fr, mingo@elte.hu,
       colpatch@us.ibm.com, nickpiggin@yahoo.com.au, rostedt@goodmis.org,
       oleg@tv-sign.ru, paulmck@us.ibm.com, menage@google.com,
       rddunlap@osdl.org, suresh.b.siddha@intel.com, tglx@linutronix.de
Subject: Re: Inquiry: Should we remove "isolcpus= kernel boot option? (may
 have realtime uses)
References: <20080601213019.14ea8ef8.pj@sgi.com>	<1212446707.6269.26.camel@lappy.programming.kicks-ass.net>	<48447C75.8040203@qualcomm.com>	<200806030156.00155.ioe-lkml@rameria.de>	<4844BB41.7000605@qualcomm.com>	<4845D825.6000403@qualcomm.com>	<20080603194148.56dfebe1.pj@sgi.com>	<48461ADA.8020303@qualcomm.com>	<877id5v1fg.fsf@basil.nowhere.org>	<20080604124126.0d281a99.pj@sgi.com>	<20080604200350.GL20824@one.firstfloor.org>	<20080604151622.a50b984f.pj@sgi.com>	<4846FC21.10304@firstfloor.org>	<20080604153819.3a3a5256.pj@sgi.com>	<4847063B.3030706@qualcomm.com> <20080604161744.4fcf7805.pj@sgi.com>
In-Reply-To: <20080604161744.4fcf7805.pj@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Paul Jackson wrote:
> Max wrote:
>> Paul, I beleive you mentioned a while ago that the tools you guys use for this
>> aren't open source. Has that changed ?
> 
> No change.

Ack.

What do you of that idea btw ? ie Generally available "syspart" thing.

Max

