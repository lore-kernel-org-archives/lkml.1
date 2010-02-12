Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757282Ab0BLQoy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 11:44:54 -0500
Received: from bamako.nerim.net ([62.4.17.28]:59777 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756936Ab0BLQow (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 11:44:52 -0500
Date: Fri, 12 Feb 2010 17:44:50 +0100
From: Jean Delvare <khali@linux-fr.org>
To: rostedt@goodmis.org
Cc: lasse.collin@tukaani.org, mirrors@kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "FTPAdmin Kernel.org" <ftpadmin@kernel.org>, users@kernel.org
Subject: Re: [kernel.org users] XZ Migration discussion
Message-ID: <20100212174450.4239f3a6@hyperion.delvare>
In-Reply-To: <1265992239.24271.38.camel@gandalf.stny.rr.com>
References: <4B744E13.8040004@kernel.org>
	<20100212150137.648dca7c@hyperion.delvare>
	<1265988318.24271.30.camel@gandalf.stny.rr.com>
	<20100212171149.5c9f78d2@hyperion.delvare>
	<1265992239.24271.38.camel@gandalf.stny.rr.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Feb 2010 11:30:39 -0500, Steven Rostedt wrote:
> On Fri, 2010-02-12 at 17:11 +0100, Jean Delvare wrote:
> 
> > What would you consider a reasonable turnaround time? 3 month? 6 month?
> > More?
> > 
> > We could make a decision now, you update ketchup immediately, and the
> > actual change happens at the specified date in the future.
> > 
> 
> Usually users don't update ketchup until it breaks ;)
> 
> But sure, 3 months probably would be fine. Then Matt Mackall will start
> getting emails about it not working, and he will forward them to me.
> Where I can then point them to the new repository.

You can probably anticipate this a bit by warning the maintainers of
the ketchup package in openSUSE, Fedora etc.

-- 
Jean Delvare
