Return-Path: <linux-kernel-owner+w=401wt.eu-S1755032AbXDZUk5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755032AbXDZUk5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 16:40:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755039AbXDZUk4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 16:40:56 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:36347 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755022AbXDZUk4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 16:40:56 -0400
Date: Thu, 26 Apr 2007 22:41:46 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Peter Keilty <peter.keilty@hp.com>
Cc: linux-ia64@vger.kernel.org, John Stultz <johnstul@us.ibm.com>,
       Eric Whitney <eric.whitney@hp.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] ia64: convert to use clocksource code
Message-ID: <20070426204146.GA25142@uranus.ravnborg.org>
References: <20070426202632.23343.54944.sendpatchset@rambler.zko.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070426202632.23343.54944.sendpatchset@rambler.zko.hp.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2007 at 04:26:32PM -0400, Peter Keilty wrote:
> From: Peter Keilty <peter.keilty@hp.com>
> 
> Initial ia64 conversion to the generic timekeeping/clocksource code.
> 
> Signed-off-by: Peter Keilty <peter.keilty@hp.com>
> Signed-off-by: John Stultz <johnstul@us.ibm.com>

The "Signed-off-by:" should reflect the order in which a path is processed
with the last submitter at the bottom of the list.
So if this patch came from John then he should be first in the list
and since the patch passes you and you submit it you should be in the bottom
of the list.

And "Signed-off-by:" tell the path that the patch takes. It is not to be used
to let others say "I have seen it and I think the patch is ok".
For the latter we have "Acked-by:".

I did not look at the code so ne feedback there.

	Sam
