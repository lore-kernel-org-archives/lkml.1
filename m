Return-Path: <linux-kernel-owner+w=401wt.eu-S1755322AbXIANxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322AbXIANxv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 09:53:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753216AbXIANxo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 09:53:44 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:51520 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752868AbXIANxn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 09:53:43 -0400
Message-ID: <46D96EE3.9050101@garzik.org>
Date: Sat, 01 Sep 2007 09:53:39 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       "Robert P. J. Day" <rpjday@mindspring.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: maturity and status and attributes, oh my!
References: <Pine.LNX.4.64.0708311720140.29153@localhost.localdomain> <46D89800.8080701@s5r6.in-berlin.de> <Pine.LNX.4.64.0708312109580.7060@localhost.localdomain> <46D92D8E.9020508@s5r6.in-berlin.de> <Pine.LNX.4.64.0709010513460.28329@localhost.localdomain> <46D93544.2030308@s5r6.in-berlin.de> <Pine.LNX.4.64.0709011514200.11617@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0709011514200.11617@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Sep 1 2007 11:47, Stefan Richter wrote:
>> Robert P. J. Day wrote:
>>> given the possible
>>> interpretations of EXPERIMENTAL that i hadn't considered until now,
>>> maybe it really *does* make sense to tag something as both
>>> EXPERIMENTAL and, say, DEPRECATED (does it?).
>> In theory maybe, for communication purposes perhaps rather not.
> 
> devfs would have been a good starting point for
> EXPERIMENTAL && (DECPREATED || OBSOLETE).

Humorous or not, this serves to indicate how synonymous 'deprecated' and 
'obsolete' are.

	Jeff



