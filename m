Return-Path: <linux-kernel-owner+w=401wt.eu-S933032AbZJFTY4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933032AbZJFTY4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 15:24:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932694AbZJFTYz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 15:24:55 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:33024 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932464AbZJFTYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 15:24:55 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4ACB992C.3000406@s5r6.in-berlin.de>
Date: Tue, 06 Oct 2009 21:23:24 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.22) Gecko/20090926 SeaMonkey/1.1.17
MIME-Version: 1.0
To: Frans Pop <elendil@planet.nl>
CC: torvalds@linux-foundation.org, mingo@elte.hu, hohndel@infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.32-rc3
References: <alpine.LFD.2.01.0910041727310.3432@localhost.localdomain> <alpine.LFD.2.00.0910052140100.309@localhost.localdomain> <1254797502.14122.146.camel@dhohndel-mobl.amr.corp.intel.com> <alpine.LFD.2.01.0910060705240.3432@localhost.localdomain> <20091006144449.GA23078@elte.hu> <alpine.LFD.2.01.0910060815320.3432@localhost.localdomain> <alpine.LFD.2.01.0910060815320.3432@localhost.localdomain> <alpine.LFD.2.01.0910060828530.3432@localhost.localdomain> <200910061909.35878.elendil@planet.nl> <200910061909.35878.elendil@planet.nl> <4ACB7F9C.9090606@s5r6.in-berlin.de> <200910062023.11298.elendil@planet.nl>
In-Reply-To: <200910062023.11298.elendil@planet.nl>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frans Pop wrote:
> On Tue, 6 Oct 2009, Stefan Richter wrote:
>> Frans Pop wrote:
>>> Developers are supposed to be able to take care of themselves;
>> _People who build kernels from sources which differ from releases_ are
>> supposed to take care of themselves.
> 
> OK. I can agree with that too. It does take some time to learn to take care 
> of oneself though. The point was that contributors start out as users; 
> some will gradually become developers.

The distinction between "users" and "developers" doesn't make sense to
me in the first place.

> And remember that developers also do often *ask* regular users to "try the
> current mainline", even during the merge window. Maybe that is something 
> that is done too lightly?

Do they?  Perhaps the "developers" know what experience and resources
are available to the particular "user", or otherwise put into context
what might be required for the discussed test.

Anyway.  Remember, you ultimately cannot remote-control what people have
in their $(kernelrelease).  You can only tell them that they can set the
local version to an explicit or automatic value if a meaningful
$(kernelrelease) is desired despite working with an unreleased source.
-- 
Stefan Richter
-=====-==--= =-=- --==-
http://arcgraph.de/sr/
