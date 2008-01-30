Return-Path: <linux-kernel-owner+w=401wt.eu-S1757857AbYA3Iuv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757857AbYA3Iuv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 03:50:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754625AbYA3Ium
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 03:50:42 -0500
Received: from jenny.ondioline.org ([66.220.1.122]:46472 "EHLO
	jenny.ondioline.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754478AbYA3Iul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 03:50:41 -0500
X-Greylist: delayed 510 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 Jan 2008 03:50:41 EST
From: Paul Collins <paul@burly.ondioline.org>
To: Theodore Tso <tytso@mit.edu>
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] ext4 update
References: <E1JJjMo-00011j-EU@closure.thunk.org>
	<20080129125307.GF6774@mit.edu>
	<Pine.LNX.4.64.0801292250110.14907@fbirervta.pbzchgretzou.qr>
	<20080130071123.GF21944@mit.edu>
Date: Wed, 30 Jan 2008 21:38:43 +1300
In-Reply-To: <20080130071123.GF21944@mit.edu> (Theodore Tso's message of "Wed,
	30 Jan 2008 02:11:23 -0500")
Message-ID: <87lk67d7xo.fsf@burly.wgtn.ondioline.org>
User-Agent: Gnus/5.110007 (No Gnus v0.7) Emacs/23.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso <tytso@MIT.EDU> writes:

> On Tue, Jan 29, 2008 at 10:54:03PM +0100, Jan Engelhardt wrote:
>> 
>> I am seeing normal behavior:
>>
>> 22:52 sovereign:~/linux > git diff HEAD | diffstat
>
> That's because you are doing a diff stat of changes that haven't been
> checked in yet.  I was doing a "git log -p origin.. | diffstat -p1",
> and in that incantation you definitely do need the -p1 to diffstat.

How about git diff --stat origin.. ?

-- 
Paul Collins
Wellington, New Zealand

Dag vijandelijk luchtschip de huismeester is dood
