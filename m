Return-Path: <linux-kernel-owner+w=401wt.eu-S1754033AbXIAJ1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033AbXIAJ1Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 05:27:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752636AbXIAJ1P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 05:27:15 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:54199 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbXIAJ1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 05:27:15 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46D9306C.9040301@s5r6.in-berlin.de>
Date: Sat, 01 Sep 2007 11:27:08 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20070807 SeaMonkey/1.1.4
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@mindspring.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: maturity and status and attributes, oh my!
References: <Pine.LNX.4.64.0708311720140.29153@localhost.localdomain> <46D89800.8080701@s5r6.in-berlin.de> <Pine.LNX.4.64.0709010435070.26137@localhost.localdomain>
In-Reply-To: <Pine.LNX.4.64.0709010435070.26137@localhost.localdomain>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert P. J. Day wrote:
> you take advantage of that?  you'd have to add a new
> structure to "make config" along the following lines:
> 
>   Along with maturity-untagged features, what other maturity levels
>   would you like to see and be able to select?

Most (all?) users and presumably most distributors/packagers don't
decide this globally.  They look at a feature and decide, based on their
need for this feature, whether they enable or disable it, whether they
look into alternative hardware/drivers/apps, whether they get in touch
with the maintainer.
-- 
Stefan Richter
-=====-=-=== =--= ----=
http://arcgraph.de/sr/
