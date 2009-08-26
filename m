Return-Path: <linux-kernel-owner+w=401wt.eu-S1753890AbZHZV0a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890AbZHZV0a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 17:26:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753869AbZHZV03
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 17:26:29 -0400
Received: from smtp4.ultrahosting.com ([74.213.175.253]:57914 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753771AbZHZV01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 17:26:27 -0400
Date: Wed, 26 Aug 2009 17:26:19 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Ingo Molnar <mingo@elte.hu>
cc: Peter Zijlstra <peterz@infradead.org>, raz ben yehuda <raziebe@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Chris Friesen <cfriesen@nortel.com>, Mike Galbraith <efault@gmx.de>,
       riel@redhat.com, andrew motron <akpm@linux-foundation.org>,
       wiseman@macs.biu.ac.il, lkml <linux-kernel@vger.kernel.org>,
       linux-rt-users@vger.kernel.org
Subject: Re: RFC: THE OFFLINE SCHEDULER
In-Reply-To: <20090826210812.GA22765@elte.hu>
Message-ID: <alpine.DEB.1.10.0908261718420.19579@gentwo.org>
References: <1251297910.1791.22.camel@maxim-laptop> <1251298443.4791.7.camel@raz> <1251300625.18584.18.camel@twins> <alpine.DEB.1.10.0908261136590.9933@gentwo.org> <1251302598.18584.31.camel@twins> <alpine.DEB.1.10.0908261211340.9933@gentwo.org>
 <20090826180407.GA13632@elte.hu> <alpine.DEB.1.10.0908261509580.9933@gentwo.org> <20090826193252.GA14721@elte.hu> <alpine.DEB.1.10.0908261627110.5554@gentwo.org> <20090826210812.GA22765@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Aug 2009, Ingo Molnar wrote:

> I'm saying that your lack of trying to reduce even low-hanging-fruit
> latency sources that were pointed out to you fundamentally destroys
> your credibility in claiming that they are unfixable for all
> practical purposes.

I have never claimed that they are unfixable. However, reducing latencies
does not remove a disturbance.

> Or, to come up with a car analogy: it's a bit as if at a repair shop
> you complained that your car has a scratch on its cooler grid that
> annoys you, and you insisted that it be outfitted with a new diesel
> engine which needs no cooler grid (throwing away the nice Hemi block
> it has currently) - and ignored the mechanic's opinion that he loves
> the Hemi and that to him the scratch looks very much like bird-sh*t
> and that a proper car wash might do the trick too ;-)

Nope. Its like you want to get rid of your car and the person you talk to
tries to convince you to keep it. He claims if you would just wash it and
repair it then it will be maybe become almost invisible and you would have
reached your goal of not having a car.

> That would benefit ordinary Linux users too, not just rare isolation
> apps.

We are talking about apps that need isolation here not regular app.
