Return-Path: <linux-kernel-owner+w=401wt.eu-S1751152AbZHaHSt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751152AbZHaHSt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 03:18:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750938AbZHaHSt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 03:18:49 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:45746 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927AbZHaHSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 03:18:48 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH] pagemap: export KPF_HWPOISON
Cc: kosaki.motohiro@jp.fujitsu.com, Josh Triplett <josh@joshtriplett.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Christoph Lameter <cl@linux-foundation.org>
In-Reply-To: <20090831071425.GA26634@localhost>
References: <20090831065659.GA18039@localhost> <20090831071425.GA26634@localhost>
Message-Id: <20090831161735.1A73.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 31 Aug 2009 16:18:48 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This flag indicates a hardware detected memory corruption on the page.
> Any future access of the page data may bring down the machine.
> 
> CC: Andi Kleen <andi@firstfloor.org>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>

Looks good to me.
	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>



