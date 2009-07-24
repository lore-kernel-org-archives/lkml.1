Return-Path: <linux-kernel-owner+w=401wt.eu-S1752279AbZGXPlC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752279AbZGXPlC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 11:41:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751530AbZGXPlB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 11:41:01 -0400
Received: from mail2.shareable.org ([80.68.89.115]:53075 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbZGXPlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 11:41:01 -0400
Date: Fri, 24 Jul 2009 16:40:36 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: sen wang <wangsen.linux@gmail.com>, mingo@elte.hu,
       akpm@linux-foundation.org, kernel@kolivas.org, npiggin@suse.de,
       arjan@infradead.org, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: report a bug about sched_rt
Message-ID: <20090724154036.GG27755@shareable.org>
References: <454c71700907240357l61f5c4fajaca73db0fba7db8@mail.gmail.com> <1248437670.6987.26.camel@twins> <454c71700907240604h4673f117j8ed58b9f2ee54798@mail.gmail.com> <1248441290.6987.52.camel@twins> <454c71700907240626w127fd890ufa91ef90cbcaaa@mail.gmail.com> <1248442415.6987.56.camel@twins> <454c71700907240644h7469e2a5sfcb57f202a2e184d@mail.gmail.com> <1248443656.6987.61.camel@twins> <454c71700907240724u76b970e5y5af0fc114cc92f83@mail.gmail.com> <1248446910.6987.111.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248446910.6987.111.camel@twins>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> If you're using the bandwidth throttle to control your RT tasks so as
> not to starve your SCHED_OTHER tasks, then I will call your system ill
> designed.

What mechanism should be used to avoid starving SCHED_OTHER tasks, in
the event there are unforeseen bugs or unpredictable calculation times
in an RT task?

Thanks,
-- Jamie
