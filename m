Return-Path: <linux-kernel-owner+w=401wt.eu-S1753234Ab0ADFrQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234Ab0ADFrQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 00:47:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752982Ab0ADFrP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 00:47:15 -0500
Received: from snt0-omc4-s27.snt0.hotmail.com ([65.55.90.230]:41885 "EHLO
	snt0-omc4-s27.snt0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750824Ab0ADFrP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 00:47:15 -0500
Message-ID: <SNT125-W149307D1A737021C150C9CC3740@phx.gbl>
X-Originating-IP: [96.253.143.208]
From: Yuhong Bao <yuhongbao_386@hotmail.com>
To: <arjan@infradead.org>
CC: <ch@zeha.at>, <linux-kernel@vger.kernel.org>, <bruce.w.allan@intel.com>,
       <jpiszcz@lucidpixels.com>
Subject: RE: Linux* is not supported on the Intel(R) Desktop Board DP55KG -
 Kernel still hangs upon reboot.
Date: Sun, 3 Jan 2010 21:47:14 -0800
Importance: Normal
In-Reply-To: <20100103150300.170dedee@infradead.org>
References: <20100103202345.GA20015@percival.namespace.at>
 <alpine.DEB.2.00.1001031637230.17894@p34.internal.lan>,<20100103150300.170dedee@infradead.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 04 Jan 2010 05:47:14.0739 (UTC) FILETIME=[5E242030:01CA8D01]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> btw this can be automated... just needs a DMI quirk.
> someone needs to get dmidecode output and add it to the existing
> table of reboot= quirks...
>
>
>
> --
> Arjan van de Ven Intel Open Source Technology Centre

Note BTW that this is one of Intel's own motherboards!
In fact, I also have read about Intel's own DG45FC board having EHCI handoff trouble with Linux.

Yuhong Bao
 		 	   		  
_________________________________________________________________
Hotmail: Trusted email with powerful SPAM protection.
http://clk.atdmt.com/GBL/go/177141665/direct/01/