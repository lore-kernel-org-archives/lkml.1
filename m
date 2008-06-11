Return-Path: <linux-kernel-owner+w=401wt.eu-S1760821AbYFKTMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760821AbYFKTMY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 15:12:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751936AbYFKTMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 15:12:15 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:2261 "EHLO
	VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175AbYFKTMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 15:12:14 -0400
X-BigFish: VPS-37(z1fc9iz1432R98dR7efV1805Mzz10d3izzz2fh6bh61h)
X-Spam-TCS-SCL: 0:0
Message-ID: <48502304.1030304@am.sony.com>
Date: Wed, 11 Jun 2008 12:09:56 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Rob Landley <rob@landley.net>, Adrian Bunk <bunk@kernel.org>,
       linux-tiny <Linux-tiny@selenic.com>,
       linux-embedded <linux-embedded@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: mainlining min-configs...
References: <48447615.5050806@am.sony.com> <20080610183004.GG11685@cs181133002.pp.htv.fi> <20080610185123.GA15838@uranus.ravnborg.org> <200806110009.22542.rob@landley.net> <20080611063921.GA27978@uranus.ravnborg.org>
In-Reply-To: <20080611063921.GA27978@uranus.ravnborg.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Jun 2008 19:11:57.0762 (UTC) FILETIME=[04C7C220:01C8CBF7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
>>> When I get my kconfig patchset polished you will be able to do:
>>>
>>> make K=my_mini_config allnoconfig
>> So you're renaming KCONFIG_ALLNOCONFIG then?
> 
> Somehow yes. The K= notation I hope will see more use. Only very few
> people know the KCONFIG_ALL*CONFIG= trick.

Indeed.  I had never heard of it, but it appears to have been
around for at least 18 months.  It looks like Randy Dunlap tried
to submit some documentation for this in Oct 2006, but it didn't
make it in?

Is this feature widely used?  Should it be doc'ed now
or are you about to make it obsolete?
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

