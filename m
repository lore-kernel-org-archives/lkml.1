Return-Path: <linux-kernel-owner+w=401wt.eu-S1754137AbXITJ6d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137AbXITJ6d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 05:58:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750884AbXITJ60
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 05:58:26 -0400
Received: from mx12.go2.pl ([193.17.41.142]:47196 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750758AbXITJ60 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 05:58:26 -0400
Date: Thu, 20 Sep 2007 12:00:31 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: "Ahmed S\. Darwish" <darwish.07@gmail.com>
Cc: Low Yucheng <ylow@andrew.cmu.edu>, Oleg Verych <olecom@flower.upol.cz>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: PROBLEM: System Freeze on Particular workload with kernel 2.6.22.6
Message-ID: <20070920100031.GA2796@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070919192546.GA3153@Ahmed>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 19-09-2007 21:25, Ahmed S. Darwish wrote:
> Hi Low,
> 
> On Wed, Sep 19, 2007 at 12:16:39PM -0400, Low Yucheng wrote:
>> There are no additional console messages.
>> Not sure what this is: * no relevant Cc (memory management added)
> 
> Relevant CCs means CCing maintainers or subsystem mailing lists related to your
> bug report. i.e, if it's a networking bug, you need to CC the linux kernel
> networking mailing list. If it's a kobject bug, you need to CC its maintainer
> (Greg) and so on.

So, which one do you recommend here?

Regards,
Jarek P.

PS#1: I don't think we should require from users so much expertise
in bug reporting: after a few questions cc-ing should be no problem
here.

PS#2: Low Yucheng: maybe it's something else, but it seems your swap
could be bigger for this amount of memory. (You could try to monitor
this e.g. with "top" running in another console window.)
