Return-Path: <linux-kernel-owner+w=401wt.eu-S1757762AbXH1NYs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757762AbXH1NYs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 09:24:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752817AbXH1NYj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 09:24:39 -0400
Received: from mail.tmr.com ([64.65.253.246]:34326 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752511AbXH1NYj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 09:24:39 -0400
Message-ID: <46D421F6.50205@tmr.com>
Date: Tue, 28 Aug 2007 09:24:06 -0400
From: Bill Davidsen <davidsen@tmr.com>
Organization: TMR Associates Inc, Schenectady NY
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Michael Evans <mjevans1983@gmail.com>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
       "Michael J. Evans" <mjevans1983@comcast.net>,
       Neil Brown <neilb@suse.de>, Ingo Molnar <mingo@redhat.com>,
       linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch v3 1/1] md: Software Raid autodetect dev list not array
References: <200708222058.45480.mjevans1983@comcast.net>	 <200708271516.21889.mjevans1983@comcast.net>	 <20070827153020.43788e21.randy.dunlap@oracle.com>	 <200708272138.19785.mjevans1983@comcast.net>	 <46D3A8AD.6000701@oracle.com> <4877c76c0708280608m529296edgd83f9c08e3918815@mail.gmail.com>
In-Reply-To: <4877c76c0708280608m529296edgd83f9c08e3918815@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Evans wrote:
> Oh, I see.  I forgot about the changelogs.  I'd send out version 5
> now, but I'm not sure what kernel version to make the patch against.
> 2.6.23-rc4 is on kernel.org and I don't see any git snapshots.
> Additionally I never could tell what git tree was the 'mainline' as it
> isn't labeled with such a keyword (at least in the list of git trees I
> saw).

I suspect you wait for 2.5.23 release, or send it to AKPM for inclusion 
in an "-mm" kernel. That's probably desirable, anyway.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

