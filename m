Return-Path: <linux-kernel-owner+w=401wt.eu-S1756334AbXGHHf5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756334AbXGHHf5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 03:35:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752831AbXGHHft
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 03:35:49 -0400
Received: from main.gmane.org ([80.91.229.2]:38282 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752629AbXGHHfs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 03:35:48 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Oleg Verych <olecom@flower.upol.cz>
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway (philosophical)
Date: Sun, 8 Jul 2007 07:35:25 +0000 (UTC)
Organization: Palacky University in Olomouc, experimental physics department.
Message-ID: <slrnf915mk.bju.olecom@flower.upol.cz>
References: <1183676393.3388.89.camel@localhost.localdomain> <Pine.LNX.4.44L0.0707061111050.3737-100000@iolanthe.rowland.org>
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: flower.upol.cz
User-Agent: slrn/0.9.8.1pl1 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Alan Stern <Date: Fri, 6 Jul 2007 11:13:14 -0400 (EDT)>

>> Why are you guys working so hard and spending so much energy to try to
>> avoid doing the right thing is beyond my understanding...
>> 
>> > It _does_ apply to kernel threads.  That's exactly why I wrote above 
>> > that kernel threads which try to do I/O during a suspend will need 
>> > extra attention.
>> 
>> Ok none at all if you don't have a freezer.
>
> In answer to both questions: We need the freezer in order to

Non of *complex* living creatures survive motionless freezing (with
ice).

That's why stupid me just don't care about all that stuff in the
Linux. It's nice to see somebody approaches this from technical, but not
off-topical POV :). 
____

