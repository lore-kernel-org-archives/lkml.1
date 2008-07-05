Return-Path: <linux-kernel-owner+w=401wt.eu-S1753468AbYGEEFt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468AbYGEEFt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 00:05:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750873AbYGEEFj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 00:05:39 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:54490 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750793AbYGEEFi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 00:05:38 -0400
Message-ID: <486EF2EA.9060903@garzik.org>
Date: Sat, 05 Jul 2008 00:04:58 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: David Miller <davem@davemloft.net>, andi@firstfloor.org, tytso@mit.edu,
       hugh@veritas.com, akpm@linux-foundation.org,
       kosaki.motohiro@jp.fujitsu.com, mchan@broadcom.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       netdev@vger.kernel.org
Subject: Re: [bug?] tg3: Failed to load firmware "tigon/tg3_tso.bin"
References: <1215177044.10393.743.camel@pmac.infradead.org>	 <486E2260.5050503@garzik.org>	 <1215178035.10393.763.camel@pmac.infradead.org>	 <20080704.133721.98729739.davem@davemloft.net> <1215204827.3189.13.camel@shinybook.infradead.org>
In-Reply-To: <1215204827.3189.13.camel@shinybook.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Woodhouse wrote:
> But we've already stopped working on drivers/net; we're fixing the rest
> of the older drivers first. And every affected maintainer except you and
> Jeff seems _happy_ to see their drivers being brought up to date.

Disliking breakage != unhappy at driver change

Since you apparently still do not see the difference between a 
breakage-filled path to goodness, and goodness itself.

	Jeff


