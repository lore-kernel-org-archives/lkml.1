Return-Path: <linux-kernel-owner+w=401wt.eu-S1759754AbZIQBaT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759754AbZIQBaT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 21:30:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754552AbZIQBaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 21:30:18 -0400
Received: from gate.crashing.org ([63.228.1.57]:59455 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754200AbZIQBaR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 21:30:17 -0400
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Frans Pop <elendil@planet.nl>
Cc: arjan@infradead.org, realnc@arcor.de, linux-kernel@vger.kernel.org
In-Reply-To: <200909162027.29850.elendil@planet.nl>
References: <20090906205952.GA6516@elte.hu>
	 <200909082222.44828.elendil@planet.nl> <1252489988.26522.46.camel@pasglop>
	 <200909091355.56335.elendil@planet.nl>
	 <200909091355.56335.elendil@planet.nl> <1252632981.8566.10.camel@pasglop>
	 <200909162027.29850.elendil@planet.nl>
Content-Type: text/plain
Date: Thu, 17 Sep 2009 11:29:59 +1000
Message-Id: <1253150999.8375.329.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-16 at 20:27 +0200, Frans Pop wrote:
> Benjamin Herrenschmidt wrote:
> > I'll have a look after the merge window madness. Multiple windows is
> > also still an option I suppose even if i don't like it that much: we
> > could support double-click on an app or "global" in the left list,
> > making that pop a new window with the same content as the right pane for
> > that app (or global) that updates at the same time as the rest.
>  
> I have another request. If I select a specific application to watch (say a 
> mail client) but it is idle for a while and thus has no latencies, it will 
> get dropped from the list and thus my selection of it will be lost.
> 
> It would be nice if in that case a selected application would stay visible 
> and selected, or maybe get reselected automatically when it appears again.

Hrm... I though I forced the selected app to remain ... or maybe I
wanted to do that and failed :-) Ok. On the list. Please ping me next
week if nothing happens.

Ben.


