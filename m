Return-Path: <linux-kernel-owner+w=401wt.eu-S1759403AbYLKXNA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759403AbYLKXNA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 18:13:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757593AbYLKXMu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 18:12:50 -0500
Received: from relay2.sgi.com ([192.48.179.30]:48063 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752260AbYLKXMt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 18:12:49 -0500
Message-ID: <49419E6F.2000209@sgi.com>
Date: Thu, 11 Dec 2008 15:12:47 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, Joerg Roedel <joro@8bytes.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.28-rc8
References: <alpine.LFD.2.00.0812101651130.3340@localhost.localdomain> <20081211084058.GE24323@8bytes.org> <20081211225723.GD10890@mit.edu>
In-Reply-To: <20081211225723.GD10890@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
> On Thu, Dec 11, 2008 at 09:40:58AM +0100, Joerg Roedel wrote:
>> On Wed, Dec 10, 2008 at 05:04:39PM -0800, Linus Torvalds wrote:
>>>  (a) just make the -rc's go on a few more weeks, and do 2.6.28 after xmas
>>>
>>>      I like this, because alledgely people are debugging things, and we'd 
>>>      get a more stable 2.6.28.
>>>
>> I'll vote for a. An open merge window over the holidays possible results
>> in needless stresses for the developers at a time which some of them
>> want to use otherwise. Or if any merge introduces bad bugs and the
>> developers that can fix it are on xmax vacation we may end up with an
>> unusable upstream tree for a week or so. Same with merge conflicts.
>> So, I'd suggest to wait until everybody is back to work until opening
>> the merge window.
> 
> I'd vote for (a) as well, and hopefully folks who are really
> conscientious can do some integration testing of linux-next and can
> report problems there to make the merge window go more smoothly after
> the New Year's.
> 
> 							- Ted

I'll second (or third?) this motion... ;-)

Thanks,
Mike
