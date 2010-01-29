Return-Path: <linux-kernel-owner+w=401wt.eu-S1756203Ab0A2Ic0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203Ab0A2Ic0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 03:32:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754399Ab0A2Ic0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 03:32:26 -0500
Received: from snt0-omc2-s3.snt0.hotmail.com ([65.55.90.78]:62714 "EHLO
	snt0-omc2-s3.snt0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753864Ab0A2IcZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 03:32:25 -0500
Message-ID: <SNT125-W19030A547D5C2C8841E0FC35B0@phx.gbl>
X-Originating-IP: [96.253.143.208]
From: Yuhong Bao <yuhongbao_386@hotmail.com>
To: <prakash@punnoor.de>, <andi@firstfloor.org>
CC: <mingo@elte.hu>, <tglx@linutronix.de>, <lenb@kernel.org>,
       <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] Replace nvidia timer override quirk with pci id list
Date: Fri, 29 Jan 2010 00:32:24 -0800
Importance: Normal
In-Reply-To: <200802082000.39919.prakash@punnoor.de>
References: <20080207195519.GA21772@basil.nowhere.org>
 <200802081839.18267.prakash@punnoor.de>
 <20080208190143.GB11573@one.firstfloor.org>,<200802082000.39919.prakash@punnoor.de>
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 29 Jan 2010 08:32:24.0964 (UTC) FILETIME=[956C3440:01CAA0BD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> So come up with a patch
> that makes sense (and triggers on my nforce2 and does not trigger on my
> mcp51) in my eyes, or I won't test anything and keep the NAK.
Yea, just delete the MCP51 from the list. Then we can get the patch finally applied.

Yuhong Bao
 		 	   		  
_________________________________________________________________
Hotmail: Trusted email with Microsoft’s powerful SPAM protection.
http://clk.atdmt.com/GBL/go/196390706/direct/01/