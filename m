Return-Path: <linux-kernel-owner+w=401wt.eu-S1755255AbYDUHYK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255AbYDUHYK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 03:24:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752550AbYDUHX5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 03:23:57 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:47390 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751955AbYDUHX4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 03:23:56 -0400
Message-ID: <480C4108.6050709@garzik.org>
Date: Mon, 21 Apr 2008 03:23:52 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, Patrick McHardy <kaber@trash.net>,
       "David S. Miller" <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [bug] build failure in net/netfilter/nf_conntrack_sip.c, on latest
 -git
References: <20080419100034.GA9475@elte.hu>
In-Reply-To: <20080419100034.GA9475@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> btw., i found no thread to reply to on lkml or elsewhere - arent all git 
> pull requests supposed to be Cc:-ed to lkml, with shortlog included?

That's in the realm of maintainer choice, much like plenty of other 
engineering practices.  There is no "rule" as such.

	Jeff



