Return-Path: <linux-kernel-owner+w=401wt.eu-S1753797AbXECOpU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753797AbXECOpU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 10:45:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754236AbXECOpU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 10:45:20 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:57237 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753797AbXECOpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 10:45:17 -0400
Date: Thu, 3 May 2007 20:23:18 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: Damien Wyart <damien.wyart@free.fr>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: [patch] CFS scheduler, -v8
Message-ID: <20070503145318.GA17776@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <46399B51.9040608@dunaweb.hu> <20070503130201.GA9000@elte.hu> <20070503132932.GA4204@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070503132932.GA4204@localhost.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2007 at 03:29:32PM +0200, Damien Wyart wrote:
> What are your thoughts/plans concerning merging CFS into mainline ? Is
> it a bit premature to get it into 2.6.22 ? I remember Linus was ok to
> change the default scheduler rapidly (the discussion was about sd at
> that time) to get more testing than in -mm.

And what about group scheduling extensions? Do you have plans to work on
it? I was begining to work on a prototype to do group scheduling based
on CFS, basically on the lines of what you and Linus had outlined
earlier:

	http://lkml.org/lkml/2007/4/18/271
	http://lkml.org/lkml/2007/4/18/244

-- 
Regards,
vatsa
