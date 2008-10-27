Return-Path: <linux-kernel-owner+w=401wt.eu-S1751597AbYJ0OjI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751597AbYJ0OjI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 10:39:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752398AbYJ0Oim
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 10:38:42 -0400
Received: from ox1.aei.mpg.de ([194.94.224.6]:38034 "EHLO ox1.aei.mpg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752308AbYJ0Oil (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 10:38:41 -0400
X-Greylist: delayed 1730 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Oct 2008 10:38:40 EDT
Date: Mon, 27 Oct 2008 15:10:42 +0100
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: Soeren Sonnenburg <kernel@nn7.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.28-rc2 regression] hangs on wakeup from s2ram
Message-ID: <20081027141042.GA7104@localhost.aei.mpg.de>
References: <1225106897.5125.6.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225106897.5125.6.camel@localhost>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 27.Oct'08 at 12:28:17 +0100, Soeren Sonnenburg wrote:
> Dear all,
> 
> my macbook pro 1,1 suspends nicely (s2ram) but on wakeup I see a black
> screen...
> 
> Does anyone else observe this? As this was from within X (and it still
> works in .27) I cannot give more details without further investigations
> from the cmdline...

This is also happening with my Vaio, and 2.6.27 works fine suspending
to RAM from inside X.

I was silent about this issue (it happened before -rc1) because I really
did not have the time to bisect it, which I think is the best way to
solve this issues quickly.

I will try to bisect it in the next days, but I can't promiss anything.


