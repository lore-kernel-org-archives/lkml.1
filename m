Return-Path: <linux-kernel-owner+w=401wt.eu-S1764815AbYBMBZR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764815AbYBMBZR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 20:25:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753776AbYBMBZD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 20:25:03 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36893
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751953AbYBMBZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 20:25:00 -0500
Date: Tue, 12 Feb 2008 17:25:32 -0800 (PST)
Message-Id: <20080212.172532.233712855.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: James.Bottomley@HansenPartnership.com, jeff@garzik.org,
       arjan@infradead.org, greg@kroah.com, sfr@canb.auug.org.au,
       linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
       linux-arch@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.1.00.0802121650350.2920@woody.linux-foundation.org>
References: <alpine.LFD.1.00.0802121051341.2920@woody.linux-foundation.org>
	<20080212.163623.132476636.davem@davemloft.net>
	<alpine.LFD.1.00.0802121650350.2920@woody.linux-foundation.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 12 Feb 2008 16:53:50 -0800 (PST)

> The fact is, that "outlying code" is where we have all the bulk of the 
> code, and it's also where we have all those developers who aren't on the 
> "inside track". So we should help the outliers, not the core code. 

Good point.

For the record I write drivers that use infrastructure too
and have to deal with the API changes just as equally :-)
