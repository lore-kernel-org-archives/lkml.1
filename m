Return-Path: <linux-kernel-owner+w=401wt.eu-S1759750AbYDSKDq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759750AbYDSKDq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 06:03:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753286AbYDSKDj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 06:03:39 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46891
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753252AbYDSKDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 06:03:39 -0400
Date: Sat, 19 Apr 2008 03:03:37 -0700 (PDT)
Message-Id: <20080419.030337.244502148.davem@davemloft.net>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, kaber@trash.net,
       torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [bug] build failure in net/netfilter/nf_conntrack_sip.c, on
 latest -git
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080419100034.GA9475@elte.hu>
References: <20080419100034.GA9475@elte.hu>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Sat, 19 Apr 2008 12:00:35 +0200

> btw., i found no thread to reply to on lkml or elsewhere - arent all git 
> pull requests supposed to be Cc:-ed to lkml, with shortlog included?

I have never once done this even going all the way back to the BK
days.

I always send my pull requests directly to Linus, CC:'ing Andrew.
