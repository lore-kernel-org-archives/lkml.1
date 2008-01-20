Return-Path: <linux-kernel-owner+w=401wt.eu-S1756211AbYATU6z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211AbYATU6z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 15:58:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755618AbYATU6p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 15:58:45 -0500
Received: from ns2.suse.de ([195.135.220.15]:55474 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755568AbYATU6o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 15:58:44 -0500
From: Andi Kleen <ak@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.24 regression: reference count leak in PPPoE
Date: Sun, 20 Jan 2008 21:58:41 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <200801202053.30386.ak@suse.de> <20080120200109.GA31876@elte.hu>
In-Reply-To: <20080120200109.GA31876@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801202158.42093.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> It seems to have stopped when i stopped using ipsec and started using
> vpnc.

Kernel ipsec was active yes. However I normally don't see it although
it is often active, that was the first time I think

(except long ago) 

> (but no firm info - this was sporadic - happened every few months 
> or so) Are you using ipsec and dynamic IPs by any chance?

and the ISP uses dynamic IPs.

-Andi
