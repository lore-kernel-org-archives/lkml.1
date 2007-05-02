Return-Path: <linux-kernel-owner+w=401wt.eu-S2992959AbXEBKFS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992959AbXEBKFS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 06:05:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992996AbXEBKFS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 06:05:18 -0400
Received: from adsl-69-232-92-238.dsl.sndg02.pacbell.net ([69.232.92.238]:49845
	"EHLO gnuppy.monkey.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992959AbXEBKFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 06:05:17 -0400
Date: Wed, 2 May 2007 03:05:07 -0700
To: Ting Yang <tingy@cs.umass.edu>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>,
       William Lee Irwin III <wli@holomorphy.com>,
       "Bill Huey (hui)" <billh@gnuppy.monkey.org>
Subject: Re: [patch] CFS scheduler, -v8
Message-ID: <20070502100507.GA20142@gnuppy.monkey.org>
References: <20070501212223.GA29867@elte.hu> <4637FE0A.7090405@cs.umass.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4637FE0A.7090405@cs.umass.edu>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Bill Huey (hui) <billh@gnuppy.monkey.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 01, 2007 at 10:57:14PM -0400, Ting Yang wrote:
>  Based on my understanding, adopting something like EEVDF in CFS should 
> not be very difficult given their similarities, although I do not have 
> any idea on how this impacts the load balancing for SMP. Does this worth 
> a try?
> 
>  Sorry for such a long email :-)

An excellent long email. Thanks.

Have you looked at Con's SD ? What did you think about it analytically
and do you think that these ideas could be incorporated into that
scheduler ?

bill

