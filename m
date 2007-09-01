Return-Path: <linux-kernel-owner+w=401wt.eu-S1754028AbXIAJsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028AbXIAJsW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 05:48:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752734AbXIAJsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 05:48:10 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:54655 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495AbXIAJsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 05:48:09 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46D93544.2030308@s5r6.in-berlin.de>
Date: Sat, 01 Sep 2007 11:47:48 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20070807 SeaMonkey/1.1.4
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@mindspring.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: maturity and status and attributes, oh my!
References: <Pine.LNX.4.64.0708311720140.29153@localhost.localdomain> <46D89800.8080701@s5r6.in-berlin.de> <Pine.LNX.4.64.0708312109580.7060@localhost.localdomain> <46D92D8E.9020508@s5r6.in-berlin.de> <Pine.LNX.4.64.0709010513460.28329@localhost.localdomain>
In-Reply-To: <Pine.LNX.4.64.0709010513460.28329@localhost.localdomain>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert P. J. Day wrote:
> given the possible
> interpretations of EXPERIMENTAL that i hadn't considered until now,
> maybe it really *does* make sense to tag something as both
> EXPERIMENTAL and, say, DEPRECATED (does it?).

In theory maybe, for communication purposes perhaps rather not.

The reasoning why a feature is deprecated will typically include the
gotchas which caused the feature to be considered experimental, if such
gotchas still apply.
-- 
Stefan Richter
-=====-=-=== =--= ----=
http://arcgraph.de/sr/
