Return-Path: <linux-kernel-owner+w=401wt.eu-S1759192AbYCUQam@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759192AbYCUQam (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 12:30:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753579AbYCUQaf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 12:30:35 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:47782 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751325AbYCUQae (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 12:30:34 -0400
Date: Fri, 21 Mar 2008 18:30:19 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Justin Mattock <justinmattock@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: fglrx
Message-ID: <20080321163019.GA1434@cs181133002.pp.htv.fi>
References: <dd18b0c30803210925x755f3f07o1e2bb0cd60c9ce7e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <dd18b0c30803210925x755f3f07o1e2bb0cd60c9ce7e@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 21, 2008 at 04:25:00PM +0000, Justin Mattock wrote:
> Hello; fair enough, I did ask ati about what I should do, but there
> wasn't much help. Overall its not pretty, but If you are impatient for
> ati to come out with an update then this should get you going(for 3D).
> The problem I see is, SELinux is going out of whack due to fglrx
> wanting a cap_t effective vector.  So on the secure side I probably
> wont use fglrx until there is support for the proper capability.
> or take you're approach and look at the open ati driver.

Please stop discussing binary-only drivers on linux-kernel.

That's 100% off-topic here.

> Justin P. Mattock

Thanks
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

