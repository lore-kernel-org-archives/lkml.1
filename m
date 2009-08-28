Return-Path: <linux-kernel-owner+w=401wt.eu-S1752135AbZH1H0X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135AbZH1H0X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 03:26:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752066AbZH1H0W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 03:26:22 -0400
Received: from cantor.suse.de ([195.135.220.2]:45375 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751673AbZH1H0V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 03:26:21 -0400
From: "NeilBrown" <neilb@suse.de>
To: "Florian Weimer" <fweimer@bfk.de>
Date: Fri, 28 Aug 2009 17:23:56 +1000 (EST)
Message-ID: <6311905a247b1ec1f264f6417ed6d5d6.squirrel@neil.brown.name>
In-Reply-To: <827hwos98u.fsf@mid.bfk.de>
References: <20090824212518.GF29763@elf.ucw.cz>
    <20090825232601.GF4300@elf.ucw.cz> <4A947682.2010204@redhat.com>
    <200908262253.17886.rob@landley.net> <4A967175.5070700@redhat.com>
    <20090827221319.GA1601@ucw.cz> <4A9733C1.2070904@redhat.com>
    <827hwos98u.fsf@mid.bfk.de>
Subject: Re: raid is dangerous but that's secret
Cc: "Ric Wheeler" <rwheeler@redhat.com>, "Pavel Machek" <pavel@ucw.cz>,
       "Rob Landley" <rob@landley.net>, "Theodore Tso" <tytso@mit.edu>,
       "Goswin von Brederlow" <goswin-v-b@web.de>,
       "kernel list" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       linux-ext4@vger.kernel.org, corbet@lwn.net
User-Agent: SquirrelMail/1.4.15
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, August 28, 2009 5:11 pm, Florian Weimer wrote:
> * Ric Wheeler:
>
>> You continue to ignore the technical facts that everyone (both MD and
>> ext3) people put in front of you.
>>
>> If you have a specific bug in MD code, please propose a patch.
>
> In RAID 1 mode, it should read both copies and error out on
> mismatch. 8-)

Despite your smiley:

  no it shouldn't, and no one is making any claims about raid1 being
  unsafe, only raid4/5/6.

NeilBrown

