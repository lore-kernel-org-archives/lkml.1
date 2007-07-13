Return-Path: <linux-kernel-owner+w=401wt.eu-S934964AbXGMHu5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934964AbXGMHu5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 03:50:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756277AbXGMHuv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 03:50:51 -0400
Received: from www.osadl.org ([213.239.205.134]:60364 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755817AbXGMHuu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 03:50:50 -0400
Subject: Re: Re-2: Oops in kernel 2.6.22 rc3
From: Thomas Gleixner <tglx@linutronix.de>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: WebLab Help <help@wecltd.eu>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Dipankar Sarma <dipankar@in.ibm.com>
In-Reply-To: <6bffcb0e0707130041n297c869bs4c039c91c284dc1c@mail.gmail.com>
References: <aolo9t7lg.1jfg5be@arsen.de>
	 <6bffcb0e0707130041n297c869bs4c039c91c284dc1c@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 13 Jul 2007 09:50:48 +0200
Message-Id: <1184313048.12353.298.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-07-13 at 09:41 +0200, Michal Piotrowski wrote:
> > Would it make sense to try out the finalized (or current,
> respectively) version of the current kernel?
> 
> It always make sense.

Yes, please try with 2.6.22.1 to make sure that the problem persists,
before we go hunting solved problems.

Thanks,

	tglx


