Return-Path: <linux-kernel-owner+w=401wt.eu-S1751987AbXEXQb5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751987AbXEXQb5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 12:31:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750760AbXEXQbs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 12:31:48 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:52323 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750733AbXEXQbr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 12:31:47 -0400
Date: Thu, 24 May 2007 18:29:39 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Adrian Bunk <bunk@stusta.de>
cc: Arjan van de Ven <arjan@linux.intel.com>, Rob Landley <rob@landley.net>,
       linux-kernel@vger.kernel.org
Subject: Re: Status of CONFIG_FORCED_INLINING?
In-Reply-To: <20070523212237.GH2098@stusta.de>
Message-ID: <Pine.LNX.4.61.0705241829000.31549@yvahk01.tjqt.qr>
References: <200705231510.52932.rob@landley.net> <46549937.1030306@linux.intel.com>
 <20070523212237.GH2098@stusta.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 23 2007 23:22, Adrian Bunk wrote:
>
>And we need only two different inline levels (__always_inline and
>"let the compiler decide"), not three (__always_inline, inline and
>"let the compiler decide").

"inline" is "let the compiler decide". If it is not, then it is "let the
compiler decide, based on my bias that I think it should be inlined".


	Jan
-- 
