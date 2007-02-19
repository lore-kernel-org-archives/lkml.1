Return-Path: <linux-kernel-owner+w=401wt.eu-S1750893AbXBSKwY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750893AbXBSKwY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 05:52:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750933AbXBSKwY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 05:52:24 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57729 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750893AbXBSKwX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 05:52:23 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Zwane Mwaikambo <zwane@infradead.org>
Subject: Re: [PATCH] Don't probe for DDC on VBE1.2
Date: Mon, 19 Feb 2007 11:37:21 +0100
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Tobias Hain <tobias.hain@gmx.de>, "H. Peter Anvin" <hpa@zytor.com>
References: <Pine.LNX.4.64.0702132145460.28458@montezuma.fsmlabs.com> <200702182253.10423.ak@suse.de> <Pine.LNX.4.64.0702181636420.26450@montezuma.fsmlabs.com>
In-Reply-To: <Pine.LNX.4.64.0702181636420.26450@montezuma.fsmlabs.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702191137.21516.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> I tested the x86_64 VBE3 case (similar to Andrew's VAIO), so we just need 
> a VBE1.2 on x86_64 test.

Does this mean you want to have an updated patch or not? 

-Andi

