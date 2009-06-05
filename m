Return-Path: <linux-kernel-owner+w=401wt.eu-S1755131AbZFEEzz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755131AbZFEEzz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 00:55:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752641AbZFEEzr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 00:55:47 -0400
Received: from zcars04e.nortel.com ([47.129.242.56]:49411 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973AbZFEEzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 00:55:47 -0400
Message-ID: <4A28A540.2000306@nortel.com>
Date: Thu, 04 Jun 2009 22:55:28 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Bill Davidsen <davidsen@tmr.com>
CC: Frans Pop <elendil@planet.nl>, tglx@linutronix.de,
       george.dunlap@eu.citrix.com, davem@davemloft.net, jeremy@goop.org,
       mingo@elte.hu, dan.magenheimer@oracle.com, avi@redhat.com,
       xen-devel@lists.xensource.com, x86@kernel.org,
       linux-kernel@vger.kernel.org, Keir.Fraser@eu.citrix.com,
       torvalds@linux-foundation.org, gregkh@suse.de, kurt.hackel@oracle.com,
       Ian.Pratt@eu.citrix.com, xen-users@lists.xensource.com,
       ksrinivasan@novell.com, EAnderson@novell.com, wimcoekaerts@wimmekes.net,
       stephen.spector@citrix.com, jens.axboe@oracle.com
Subject: Re: Xen is a feature
References: <162f4c90-6431-4a2a-b337-6d7451d7b11e@default> <20090528001350.GD26820@elte.hu> <4A1F302E.8030501@goop.org> <20090528.210559.137121893.davem@davemloft.net> <4A1FCE8E.2060604@eu.citrix.com> <alpine.LFD.2.00.0905311607560.3379@localhost.localdomain> <4A26D3D8.6080002@tmr.com> <alpine.LFD.2.00.0906032204220.3419@localhost.localdomain> <alpine.LFD.2.00.0906032204220.3419@localhost.localdomain> <4A26FB3B.6010205@tmr.com> <200906040129.07852.elendil@planet.nl> <4A289B96.7030808@tmr.com>
In-Reply-To: <4A289B96.7030808@tmr.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Jun 2009 04:55:35.0182 (UTC) FILETIME=[DCAC82E0:01C9E599]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bill Davidsen wrote:

> Where it comes from is his very recent statement, which contains those 
> very words. You may interpret what he said in any way you choose, but 
> denying that he said it shows that you didn't follow the link back. I 
> never denied the ugliness of the code, nor does the author, but it adds 
> a great deal of value for many people, and that's the point I was making.

Lots of code could be said to add a great deal of value for many people
(semi-closed video card drivers, ndiswrapper, etc.), but it's never
going to be accepted into the kernel.

The maintainers get to decide whether the perceived benefit outweighs
the perceived cost.  So far, they've decided that Xen isn't worth it.

The most likely way to get Xen merged is to lower the cost (reduce the
churn and ugliness), increase the benefit (improve the virtualization
layer, thus cleaning up other code as well), or both.

Chris
