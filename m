Return-Path: <linux-kernel-owner+w=401wt.eu-S1761634AbYDZUuL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761634AbYDZUuL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 16:50:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755314AbYDZUt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 16:49:59 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:34633 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881AbYDZUt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 16:49:59 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <48139554.7030603@s5r6.in-berlin.de>
Date: Sat, 26 Apr 2008 22:49:24 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.13) Gecko/20080419 SeaMonkey/1.1.9
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@kernel.org>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: If you want me to quit I will quit
References: <1209190455.14173.13.camel@brick>	<20080426110044.GB2252@cs181133002.pp.htv.fi>	<20080426075132.b0fdbe13.akpm@linux-foundation.org>	<20080426152341.GI2252@cs181133002.pp.htv.fi>	<20080426084420.8e61c379.akpm@linux-foundation.org>	<20080426171604.GN2252@cs181133002.pp.htv.fi>	<alpine.LFD.1.10.0804261024580.2813@woody.linux-foundation.org>	<481379BB.5050208@s5r6.in-berlin.de>	<alpine.LFD.1.10.0804261153390.2813@woody.linux-foundation.org>	<alpine.LFD.1.10.0804261213320.2813@woody.linux-foundation.org> <20080426133049.187e255c.akpm@linux-foundation.org>
In-Reply-To: <20080426133049.187e255c.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> Often it takes quite a long time for problems to become apparent.  Across a
> month or two we end up with things like:
[...]
> that's two patches, each with three followon fixes.  Very common.
> 
> Fact is, this is the way in which developers want to work.  That is their
> workflow, and their tools should follow their workflow.  If a tool's
> behaviour prevents them from implementing their desired workflow, it isn't
> the workflow which should be changed ;)

Well, some of the questions here, notably
   - when to fold patch + amendment patch into a single patch
   - when to publish things to whom
are actually about the workflow, not about the tool.

(And it's good to learn of other people's expectations about it.)
-- 
Stefan Richter
-=====-==--- -=-- ==-=-
http://arcgraph.de/sr/
