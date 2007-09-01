Return-Path: <linux-kernel-owner+w=401wt.eu-S1754551AbXIANO4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551AbXIANO4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 09:14:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751947AbXIANOt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 09:14:49 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:39187 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743AbXIANOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 09:14:48 -0400
Date: Sat, 1 Sep 2007 15:14:47 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
cc: "Robert P. J. Day" <rpjday@mindspring.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: maturity and status and attributes, oh my!
In-Reply-To: <46D93544.2030308@s5r6.in-berlin.de>
Message-ID: <Pine.LNX.4.64.0709011514200.11617@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0708311720140.29153@localhost.localdomain>
 <46D89800.8080701@s5r6.in-berlin.de> <Pine.LNX.4.64.0708312109580.7060@localhost.localdomain>
 <46D92D8E.9020508@s5r6.in-berlin.de> <Pine.LNX.4.64.0709010513460.28329@localhost.localdomain>
 <46D93544.2030308@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 1 2007 11:47, Stefan Richter wrote:
>Robert P. J. Day wrote:
>> given the possible
>> interpretations of EXPERIMENTAL that i hadn't considered until now,
>> maybe it really *does* make sense to tag something as both
>> EXPERIMENTAL and, say, DEPRECATED (does it?).
>
>In theory maybe, for communication purposes perhaps rather not.

devfs would have been a good starting point for
EXPERIMENTAL && (DECPREATED || OBSOLETE).

>The reasoning why a feature is deprecated will typically include the
>gotchas which caused the feature to be considered experimental, if such
>gotchas still apply.


	Jan
-- 
