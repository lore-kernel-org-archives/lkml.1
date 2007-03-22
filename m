Return-Path: <linux-kernel-owner+w=401wt.eu-S932819AbXCVONE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932819AbXCVONE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 10:13:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932850AbXCVOND
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 10:13:03 -0400
Received: from holomorphy.com ([66.93.40.71]:40804 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932819AbXCVONC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 10:13:02 -0400
Date: Thu, 22 Mar 2007 07:11:46 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Eric Dumazet <dada1@cosmosbay.com>, Tomas M <tomas@slax.org>,
       linux-kernel@vger.kernel.org
Subject: Re: max_loop limit
Message-ID: <20070322141146.GN2986@holomorphy.com>
References: <460236CE.1030303@slax.org> <20070322110058.GB23664@tatooine.rebelbase.local> <46026A92.4020106@slax.org> <20070322144210.73dfaf83.dada1@cosmosbay.com> <20070322134230.GP19922@kernel.dk> <20070322145245.a49fefeb.dada1@cosmosbay.com> <20070322135456.GS19922@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070322135456.GS19922@kernel.dk>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22 2007, Eric Dumazet wrote:
>> Sure, but it's the first Tomas patch :)

On Thu, Mar 22, 2007 at 02:54:57PM +0100, Jens Axboe wrote:
> The more the reason to guide him in the direction of a right solution,
> instead of extending the current bad one!

On Thu, Mar 22 2007, Eric Dumazet wrote:
>> Apparently the 'current crap' didnt caugth someone else attention.

On Thu, Mar 22, 2007 at 02:54:57PM +0100, Jens Axboe wrote:
> I guess most people don't care, 8 is enough for them and the wasted
> memory isn't too much to care about - 8 devices and only one used, is
> wasting at least ~14kb on my machine here.

Any chance we can get some kind of devices set up for partitions of
loop devices if we're going to redo loopdev setup? That's been a thorn
in my side for some time.


-- wli
