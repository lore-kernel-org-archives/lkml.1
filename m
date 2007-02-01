Return-Path: <linux-kernel-owner+w=401wt.eu-S1422814AbXBALqn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422814AbXBALqn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 06:46:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422825AbXBALqn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 06:46:43 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:52499 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422814AbXBALqm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 06:46:42 -0500
Date: Thu, 1 Feb 2007 12:43:56 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Lee Revell <rlrevell@joe-job.com>
cc: Theodore Tso <tytso@mit.edu>, Greg KH <greg@kroah.com>,
       Nicolas Mailhot <nicolas.mailhot@laposte.net>,
       linux-kernel@vger.kernel.org
Subject: Re: Free Linux Driver Development!
In-Reply-To: <75b66ecd0701311559u2c1f44f9t685b3054802d9cc3@mail.gmail.com>
Message-ID: <Pine.LNX.4.61.0702011240000.13737@yvahk01.tjqt.qr>
References: <32793.192.54.193.51.1170248792.squirrel@rousalka.dyndns.org> 
 <20070131201258.GB15128@kroah.com> <20070131230014.GD20514@thunk.org>
 <75b66ecd0701311559u2c1f44f9t685b3054802d9cc3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 31 2007 18:59, Lee Revell wrote:
> On 1/31/07, Theodore Tso <tytso@mit.edu> wrote:
>>
>> More specifically, Dave said that it "seemed rude" to just take the
>> driver and send updates, but maybe the best way of dealing with
>> out-of-tree drivers like lirc is to treat the out-of-tree drivers as a
>> kind of spec release, and just have someone in the community forcibly
>> take the code, fix it up, and then get it merged.
>
> But if the maintainer is unwilling to work with the kernel developers,
> the driver won't get bugfixes or updates for new hardware.

Talk about util-linux and rpm, whose maintainers were/are unwilling to give
back the project to those who would really like to work on it.

At least I don't differentiate between userspace and kernelspace when it
comes to "hijacking projects back for the better". foobar is left where it
is, and is commonly forked into foobar-ng. It's just naming. Just pull in
lirc and tag it lirc-ng.


Jan
-- 
ft: http://freshmeat.net/p/chaostables/
