Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756710Ab0BLQLz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 11:11:55 -0500
Received: from bamako.nerim.net ([62.4.17.28]:57258 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756243Ab0BLQLy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 11:11:54 -0500
Date: Fri, 12 Feb 2010 17:11:49 +0100
From: Jean Delvare <khali@linux-fr.org>
To: rostedt@goodmis.org
Cc: "J.H." <warthog9@kernel.org>, "FTPAdmin Kernel.org" <ftpadmin@kernel.org>,
       users@kernel.org, lasse.collin@tukaani.org,
       linux-kernel <linux-kernel@vger.kernel.org>, mirrors@kernel.org
Subject: Re: [kernel.org users] XZ Migration discussion
Message-ID: <20100212171149.5c9f78d2@hyperion.delvare>
In-Reply-To: <1265988318.24271.30.camel@gandalf.stny.rr.com>
References: <4B744E13.8040004@kernel.org>
	<20100212150137.648dca7c@hyperion.delvare>
	<1265988318.24271.30.camel@gandalf.stny.rr.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Feb 2010 10:25:18 -0500, Steven Rostedt wrote:
> On Fri, 2010-02-12 at 15:01 +0100, Jean Delvare wrote:
> 
> > I wouldn't worry too much about breaking the current locations. Just
> > give some time for software authors (ketchup comes to mind) to update
> > their code and it shouldn't be a big problem.
> 
> As the new maintainer of ketchup:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/ketchup.git
> 
> I could write a fix for the new format real quick. My concern is that
> users of ketchup may not see this update for a long time.

What would you consider a reasonable turnaround time? 3 month? 6 month?
More?

We could make a decision now, you update ketchup immediately, and the
actual change happens at the specified date in the future.

-- 
Jean Delvare
