Return-Path: <linux-kernel-owner+w=401wt.eu-S1755224AbYKEVOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224AbYKEVOT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 16:14:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752066AbYKEVOJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 16:14:09 -0500
Received: from nn7.de ([85.214.94.156]:34118 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751827AbYKEVOI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 16:14:08 -0500
Subject: Re: [2.6.28-rc2 regression] hangs on wakeup from s2ram
From: Soeren Sonnenburg <kernel@nn7.de>
To: "Carlos R\. Mafra" <crmafra2@gmail.com>, Jiri Slaby <jirislaby@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20081027141042.GA7104@localhost.aei.mpg.de>
References: <1225106897.5125.6.camel@localhost>
	 <20081027141042.GA7104@localhost.aei.mpg.de>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 05 Nov 2008 22:14:05 +0100
Message-Id: <1225919645.5644.11.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-10-27 at 15:10 +0100, Carlos R. Mafra wrote:
> On Mon 27.Oct'08 at 12:28:17 +0100, Soeren Sonnenburg wrote:
> > Dear all,
> > 
> > my macbook pro 1,1 suspends nicely (s2ram) but on wakeup I see a black
> > screen...
> > 
> > Does anyone else observe this? As this was from within X (and it still
> > works in .27) I cannot give more details without further investigations
> > from the cmdline...
> 
> This is also happening with my Vaio, and 2.6.27 works fine suspending
> to RAM from inside X.
> 
> I was silent about this issue (it happened before -rc1) because I really
> did not have the time to bisect it, which I think is the best way to
> solve this issues quickly.
> 
> I will try to bisect it in the next days, but I can't promiss anything.

I still have this hang in resume -rc3+git current, but I don't have the
time to dig into this for the next 3 weeks :(

Soeren
