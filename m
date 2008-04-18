Return-Path: <linux-kernel-owner+w=401wt.eu-S1754820AbYDRKwI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820AbYDRKwI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 06:52:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750798AbYDRKv4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 06:51:56 -0400
Received: from one.firstfloor.org ([213.235.205.2]:54002 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776AbYDRKv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 06:51:56 -0400
Message-ID: <48087D42.9090807@firstfloor.org>
Date: Fri, 18 Apr 2008 12:51:46 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Alexander van Heukelum <heukelum@fastmail.fm>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [v2.6.26] what's brewing in x86.git for v2.6.26
References: <20080416202338.GA6007@elte.hu> <878wzdikwk.fsf@basil.nowhere.org> <1208426793.10305.1248377703@webmail.messagingengine.com> <20080418083824.GA9636@elte.hu>
In-Reply-To: <20080418083824.GA9636@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Andi will have to prove his points by coming up with competing benchmark 
> results - 

My point was really: "don't merge based on bogus benchmarks" or
perhaps better put: every time you see a benchmark result turn on your
brain and make sure it is really measuring something that makes sense
and also "don't put results from bogus benchmarks into change logs"

I actually don't have a big issue with the patches themselves (they
seem reasonably clean so they don't make the code worse, although I
don't think they are a significant improvement over the previous code
either), just  with the methology they were submitted.

> I dont really understand the negativism that comes from Andi - he was

I object to using bogus benchmarks.

> very much aware of the various iterations and benchmarks you did when 
> developing this rather cool feature: he participated in those threads 
> and was Cc:-ed as well. The "100% bogus benchmark with the most 

The initial "1...n" benchmark after which you merged the patch
definitely fit my "bogus" description. If there was a later better one I
had missed that indeed, sorry and I don't remember being cc'ed on one
such (except in Alexander's latest answer which satisfied me)

-Andi


