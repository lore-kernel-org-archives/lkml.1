Return-Path: <linux-kernel-owner+w=401wt.eu-S1760826AbXHaWhA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760826AbXHaWhA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 18:37:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752563AbXHaWgx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 18:36:53 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:43875 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbXHaWgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 18:36:52 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46D89800.8080701@s5r6.in-berlin.de>
Date: Sat, 01 Sep 2007 00:36:48 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20070807 SeaMonkey/1.1.4
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@mindspring.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: maturity and status and attributes, oh my!
References: <Pine.LNX.4.64.0708311720140.29153@localhost.localdomain>
In-Reply-To: <Pine.LNX.4.64.0708311720140.29153@localhost.localdomain>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert P. J. Day wrote:
...
> attributes would have two critical and non-negotiable properties:
> 
> 1) they would be entirely orthogonal to one another, and
> 2) they can be assigned at most one of a pre-defined set of values

If they are fully orthogonal to another, then they are also
nonexclusive.  You want them to be mutual exclusive, not orthogonal.

...
>   experimental -> normal (stable) -> deprecated -> obsolete
> 
>   it's a natural progression and, at any point, a feature cannot
> possibly have more than one maturity value.  it would be as absurd as
> saying that someone was a teenager *and* was a twenty-something at the
> same time.

Keep in mind though that 'experimental', in the context of Linux kernel
features, has nothing to do with the age of a feature.
-- 
Stefan Richter
-=====-=-=== =--= ----=
http://arcgraph.de/sr/
