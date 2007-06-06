Return-Path: <linux-kernel-owner+w=401wt.eu-S935463AbXFFUXo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935463AbXFFUXo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 16:23:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932650AbXFFUXf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 16:23:35 -0400
Received: from waste.org ([66.93.16.53]:41773 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753608AbXFFUXe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 16:23:34 -0400
Date: Wed, 6 Jun 2007 15:23:14 -0500
From: Matt Mackall <mpm@selenic.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Interesting interaction between lguest and CFS
Message-ID: <20070606202314.GH11115@waste.org>
References: <20070604173710.GR11166@waste.org> <20070604175436.GC30274@elte.hu> <20070604184106.GG11115@waste.org> <20070605071904.GB25163@elte.hu> <20070605140342.GR11115@waste.org> <b647ffbd0706050814u1e145b82qdb344d475d9ffe93@mail.gmail.com> <b647ffbd0706050841v2a326fb4n128249131ccbc11a@mail.gmail.com> <20070605195015.GA24348@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070605195015.GA24348@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 05, 2007 at 09:50:15PM +0200, Ingo Molnar wrote:
> Matt, could you run this for 1-2 minutes and send us the sched_debug.txt 
> output?

http://selenic.com/sched_debug.txt.gz

-- 
Mathematics is the supreme nostalgia of our time.
