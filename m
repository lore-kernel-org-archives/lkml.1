Return-Path: <linux-kernel-owner+w=401wt.eu-S1754353AbYHYPBY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754353AbYHYPBY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 11:01:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753248AbYHYPBI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 11:01:08 -0400
Received: from mx1.suse.de ([195.135.220.2]:39529 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754956AbYHYPBH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 11:01:07 -0400
Message-ID: <48B2C8E7.70504@suse.de>
Date: Mon, 25 Aug 2008 16:59:51 +0200
From: Tejun Heo <teheo@suse.de>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
Cc: Jens Axboe <jens.axboe@oracle.com>, Abdel Benamrouche <draconux@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET 1/3 blk-for-2.6.28] block: misc fixes and	improvements
References: <1219655740-11672-1-git-send-email-tj@kernel.org> <20080825144714.GA20813@suse.de> <48B2C8A0.4070100@kernel.org>
In-Reply-To: <48B2C8A0.4070100@kernel.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Greg KH wrote:
>>> Recent block_class iteration updates 5c6f35c5..27f3025 introduced a
>>> few bugs and trivial user visible behavior change.  0001-0003 update
>>> those issues and simplify related code using new class iterator.
>> The bugs should now be fixed in Linus's tree due to a fix from Kay,
>> right?
> 
> Ah.. okay, it's fixed in Linus's tree.  Anyways, what do you think about
> the new iterator?

Aiee.. never mind the last question.  I somehow missed the last
paragraph.  :-)

-- 
tejun
