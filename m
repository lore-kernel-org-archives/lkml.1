Return-Path: <linux-kernel-owner+w=401wt.eu-S1754090AbZFPMjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090AbZFPMjp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 08:39:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752037AbZFPMjf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 08:39:35 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58058
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751776AbZFPMje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 08:39:34 -0400
Date: Tue, 16 Jun 2009 05:39:37 -0700 (PDT)
Message-Id: <20090616.053937.42972913.davem@davemloft.net>
To: mingo@elte.hu
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT]: Networking
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090616122415.GA16630@elte.hu>
References: <20090616.034752.226811527.davem@davemloft.net>
	<20090616105304.GA3579@elte.hu>
	<20090616122415.GA16630@elte.hu>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Tue, 16 Jun 2009 14:24:15 +0200

> With several dozen test-cycles (and [a]x25 reactivated) it looks 
> good and stable so far.

Thanks for testing.
