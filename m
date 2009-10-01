Return-Path: <linux-kernel-owner+w=401wt.eu-S1756019AbZJAJgD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756019AbZJAJgD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 05:36:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756010AbZJAJgC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 05:36:02 -0400
Received: from Cpsmtpm-eml106.kpnxchange.com ([195.121.3.10]:52217 "EHLO
	CPSMTPM-EML106.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755649AbZJAJgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 05:36:00 -0400
From: Frans Pop <elendil@planet.nl>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
Date: Thu, 1 Oct 2009 11:36:01 +0200
User-Agent: KMail/1.9.9
Cc: arjan@infradead.org, realnc@arcor.de, linux-kernel@vger.kernel.org
References: <20090906205952.GA6516@elte.hu> <200909082222.44828.elendil@planet.nl> <1252489988.26522.46.camel@pasglop> <200909091355.56335.elendil@planet.nl> <200909091355.56335.elendil@planet.nl> <1252632981.8566.10.camel@pasglop> <200909162027.29850.elendil@planet.nl> <200909162027.29850.elendil@planet.nl> <1253150999.8375.329.camel@pasglop>
In-reply-To: <1253150999.8375.329.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910011136.03590.elendil@planet.nl>
X-OriginalArrivalTime: 01 Oct 2009 09:36:03.0508 (UTC) FILETIME=[97E1C740:01CA427A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt wrote:
> On Wed, 2009-09-16 at 20:27 +0200, Frans Pop wrote:
>> Benjamin Herrenschmidt wrote:
>> > I'll have a look after the merge window madness. Multiple windows is
>> > also still an option I suppose even if i don't like it that much: we
>> > could support double-click on an app or "global" in the left list,
>> > making that pop a new window with the same content as the right pane
>> > for that app (or global) that updates at the same time as the rest.
>>  
>> I have another request. If I select a specific application to watch (say
>> a mail client) but it is idle for a while and thus has no latencies, it
>> will get dropped from the list and thus my selection of it will be lost.
>> 
>> It would be nice if in that case a selected application would stay
>> visible and selected, or maybe get reselected automatically when it
>> appears again.
> 
> Hrm... I though I forced the selected app to remain ... or maybe I
> wanted to do that and failed :-) Ok. On the list. Please ping me next
> week if nothing happens.

As requested: ping?

And while I'm writing anyway, one more suggestion.
I find the fact that the buttons jump twice every 30 seconds (because of a 
change in the timer between <10 and >=10 seconds) slightly annoying.
Any chance of making the position of the buttons fixed? One option could be 
moving the timer to the left side of the bottom bar.

Cheers,
FJP
