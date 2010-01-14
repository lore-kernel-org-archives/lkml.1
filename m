Return-Path: <linux-kernel-owner+w=401wt.eu-S1756697Ab0ANAE5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756697Ab0ANAE5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 19:04:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755986Ab0ANAE4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 19:04:56 -0500
Received: from snt0-omc4-s30.snt0.hotmail.com ([65.55.90.233]:6810 "EHLO
	snt0-omc4-s30.snt0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755728Ab0ANAE4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 19:04:56 -0500
Message-ID: <SNT125-W54F5BC072FF872ACB07277C36A0@phx.gbl>
X-Originating-IP: [96.253.143.208]
From: Yuhong Bao <yuhongbao_386@hotmail.com>
To: <ananth@in.ibm.com>, <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>, <travis@sgi.com>
CC: <yinghai@kernel.org>, <suresh.b.siddha@intel.com>,
       <linux-kernel@vger.kernel.org>, <stable@kernel.org>, <hpa@zytor.com>,
       <tglx@linutronix.de>, <venkatesh.pallipadi@intel.com>
Subject: RE: [PATCH] Revert 2fbd07a5f so machines with BSPs phsyical apic id
 != 0 can boot
Date: Wed, 13 Jan 2010 16:03:34 -0800
Importance: Normal
In-Reply-To: <20100111045326.GA11725@in.ibm.com>
References: <20100109101038.GA17555@in.ibm.com>
 <86802c441001091313y1f64f011t616f08cd282a7123@mail.gmail.com>
 <20100110023015.GA2253@in.ibm.com>
 <86802c441001092235j79092e6fse18b61e3d7b0ac6@mail.gmail.com>
 <20100110102638.GA7838@elte.hu>,<20100111045326.GA11725@in.ibm.com>
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 14 Jan 2010 00:03:34.0699 (UTC) FILETIME=[03C537B0:01CA94AD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Booting Node 0, Processors #1masked ExtINT on CPU#1
> #2masked ExtINT on CPU#2
> #3masked ExtINT on CPU#3
> #4masked ExtINT on CPU#4
> #5masked ExtINT on CPU#5
> #6masked ExtINT on CPU#6
> #7 Ok.
> masked ExtINT on CPU#7
Looks pretty ugly.
 
Yuhong Bao
 		 	   		  
 		 	   		  
_________________________________________________________________
Hotmail: Trusted email with Microsoft’s powerful SPAM protection.
http://clk.atdmt.com/GBL/go/196390706/direct/01/