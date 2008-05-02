Return-Path: <linux-kernel-owner+w=401wt.eu-S935260AbYEBOAz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935260AbYEBOAz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 10:00:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935128AbYEBOAq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 10:00:46 -0400
Received: from cpsmtpo-eml01.kpnxchange.com ([213.75.38.150]:41947 "EHLO
	cpsmtpo-eml01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935110AbYEBOAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 10:00:46 -0400
From: Frans Pop <elendil@planet.nl>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] hfsplus: Correct user visible printk
Date: Fri, 2 May 2008 16:00:42 +0200
User-Agent: KMail/1.9.9
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org
References: <20080502142925.2e439d8a@core>
In-reply-To: <20080502142925.2e439d8a@core>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805021600.42610.elendil@planet.nl>
X-OriginalArrivalTime: 02 May 2008 14:00:42.0981 (UTC) FILETIME=[E9385150:01C8AC5C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> The verb form is "journalised". Confirmed with the OED and BCS

But daily usage stats say something completely different (google):
journaled:   1,540,000 hits
journalized:   129,000 hits
journalised:     8,340 hits

BTW, what is common spelling in the kernel British or American English?

If you search for it with "file system" added, you get:
journaled:     134,000 hits ( 8.7% of above total)
journalized:     3,290 hits ( 2.5%)
journalised:     1,890 hits (22.7%)

So "journalized" is even less common when talking about file systems than it 
is in other contexts.
Guess the high percentage for "journalised" is your doing? ;-)

I don't see this as an improvement.

Cheers,
FJP
