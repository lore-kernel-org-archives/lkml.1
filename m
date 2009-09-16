Return-Path: <linux-kernel-owner+w=401wt.eu-S1756088AbZIPS1e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756088AbZIPS1e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 14:27:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753737AbZIPS12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 14:27:28 -0400
Received: from Cpsmtpm-eml108.kpnxchange.com ([195.121.3.12]:60136 "EHLO
	CPSMTPM-EML108.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752901AbZIPS11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 14:27:27 -0400
From: Frans Pop <elendil@planet.nl>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
Date: Wed, 16 Sep 2009 20:27:28 +0200
User-Agent: KMail/1.9.9
Cc: arjan@infradead.org, realnc@arcor.de, linux-kernel@vger.kernel.org
References: <20090906205952.GA6516@elte.hu> <200909082222.44828.elendil@planet.nl> <1252489988.26522.46.camel@pasglop> <200909091355.56335.elendil@planet.nl> <200909091355.56335.elendil@planet.nl> <1252632981.8566.10.camel@pasglop>
In-reply-To: <1252632981.8566.10.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909162027.29850.elendil@planet.nl>
X-OriginalArrivalTime: 16 Sep 2009 18:27:30.0444 (UTC) FILETIME=[59C7D4C0:01CA36FB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt wrote:
> I'll have a look after the merge window madness. Multiple windows is
> also still an option I suppose even if i don't like it that much: we
> could support double-click on an app or "global" in the left list,
> making that pop a new window with the same content as the right pane for
> that app (or global) that updates at the same time as the rest.
 
I have another request. If I select a specific application to watch (say a 
mail client) but it is idle for a while and thus has no latencies, it will 
get dropped from the list and thus my selection of it will be lost.

It would be nice if in that case a selected application would stay visible 
and selected, or maybe get reselected automatically when it appears again.

Thanks,
FJP
