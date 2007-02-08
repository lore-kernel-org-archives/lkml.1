Return-Path: <linux-kernel-owner+w=401wt.eu-S1752364AbXBHR6l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752364AbXBHR6l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 12:58:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752369AbXBHR6l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 12:58:41 -0500
Received: from 65-117-135-114.dia.static.qwest.net ([65.117.135.114]:54766
	"EHLO postfix.timesys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358AbXBHR6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 12:58:40 -0500
X-Greylist: delayed 1542 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Feb 2007 12:58:40 EST
Subject: Re: One-shot high-resolution POSIX timer periodically late
From: Thomas Gleixner <tglx@timesys.com>
To: John <linux.kernel@free.fr>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       mingo@elte.hu, johnstul@us.ibm.com, akpm@osdl.org
In-Reply-To: <45C9A8FE.3090705@free.fr>
References: <fa.4zD54Ie6Ozt0P4YqQSicS+XzXGw@ifi.uio.no>
	 <fa.G+/T32f2o1M3+YGLca/O8NaAQyY@ifi.uio.no>
	 <fa.6Ua8xjNfLKQEZZgDsoJgPMyww4g@ifi.uio.no>
	 <fa.yQlV+WU0TgrJTVqjopa01tgCnT0@ifi.uio.no>
	 <fa.ucVrLJ1Lh6FjdBHRglsIUc8/evk@ifi.uio.no>
	 <fa.Id9oufyELrVbe5Wb8SRakwC0V50@ifi.uio.no>  <45C75D2D.9010506@free.fr>
	 <1170747081.4672.11.camel@twins>  <45C9A8FE.3090705@free.fr>
Content-Type: text/plain
Date: Thu, 08 Feb 2007 18:32:42 +0100
Message-Id: <1170955962.3646.51.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-02-07 at 11:25 +0100, John wrote:
> Are there people that use the -rt patch set in real industrial applications?

Yes. But we use a stabilized version of 2.6.16-rt29.
http://www.osadl.org/projects/downloads/preempt-rt/linux-2.6.16/

> It seems that, if an important bug is found in the -rt part, I will have 
> to either upgrade to the latest kernel, or back port all the -rt changes 
> to the kernel I chose for my application?

Yep.

	tglx


