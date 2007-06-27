Return-Path: <linux-kernel-owner+w=401wt.eu-S1763350AbXF0WS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763350AbXF0WS0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 18:18:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757641AbXF0WST
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 18:18:19 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:12685 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756687AbXF0WSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 18:18:18 -0400
Date: Thu, 28 Jun 2007 00:18:17 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Chris Shoemaker <c.shoemaker@cox.net>
cc: Josh Triplett <josht@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, josh@kernel.org
Subject: Re: [PATCH] CodingStyle: Add information about trailing whitespace.
In-Reply-To: <20070627180552.GA746@pe.Belkin>
Message-ID: <Pine.LNX.4.64.0706280015320.11120@fbirervta.pbzchgretzou.qr>
References: <1182967160.8970.108.camel@josh-work.beaverton.ibm.com>
 <20070627180552.GA746@pe.Belkin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 27 2007 14:05, Chris Shoemaker wrote:
>
>What I'd really like to see is, _why_ is trailing whitespace
>considered harmful?

Consumes bytes you'll never see :)

>Something about MUAs not preserving it or something?

Well, there is format=flowed. text/plain mails with a trailing blank at the end
of line indicates the paragraph continues -- as a curtesy for mail readers with
non-fixed-font to display the paragraph coherently rather than breaking it at
72/80 columns.


	Jan
-- 
