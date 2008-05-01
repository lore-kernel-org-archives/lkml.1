Return-Path: <linux-kernel-owner+w=401wt.eu-S1755906AbYEAIkF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906AbYEAIkF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 04:40:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751593AbYEAIjw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 04:39:52 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:44856 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356AbYEAIjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 04:39:51 -0400
From: kamezawa.hiroyu@jp.fujitsu.com
Message-ID: <32852601.1209631141232.kamezawa.hiroyu@jp.fujitsu.com>
Date: Thu, 1 May 2008 17:39:01 +0900 (JST)
To: Tony Battersby <tonyb@cybernetics.com>
Subject: Re: Re: [PATCH] more ZERO_PAGE handling ( was 2.6.24 regression: deadlock on coredump of big process)
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>,
       Mika Penttil? <mika.penttila@kolumbus.fi>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <48187AE5.4090807@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: @nifty Webmail 2.0
References: <48187AE5.4090807@cybernetics.com>
 <4815E932.1040903@cybernetics.com>	<20080429100048.3e78b1ba.kamezawa.hiroyu@jp.fujitsu.com>	<48172C72.1000501@cybernetics.com>	<20080430132516.28f1ee0c.kamezawa.hiroyu@jp.fujitsu.com>	<4817FDA5.1040702@kolumbus.fi>	<20080430141738.e6b80d4b.kamezawa.hiroyu@jp.fujitsu.com>	<20080430051932.GD27652@wotan.suse.de> <20080430143542.2dcf745a.kamezawa.hiroyu@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>This patch fixes the deadlock.  Tested on 2.6.24.5.  Thanks!
>
>Tested-by: Tony Battersby <tonyb@cybernetics.com>
>
thank you for test. I'll post this again when I'm back.

Regards,
-Kame
