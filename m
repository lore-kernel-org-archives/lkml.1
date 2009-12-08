Return-Path: <linux-kernel-owner+w=401wt.eu-S965849AbZLHTWb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965849AbZLHTWb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 14:22:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965847AbZLHTW1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 14:22:27 -0500
Received: from tomts20.bellnexxia.net ([209.226.175.74]:43964 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965845AbZLHTW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 14:22:26 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao4FAKMyHkuuWOw8/2dsb2JhbACBTNd1hDIE
Date: Tue, 8 Dec 2009 14:17:31 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: "David S. Miller" <davem@davemloft.net>,
       Robert Olsson <robert.olsson@its.uu.se>,
       Jens Laas <jens.laas@data.slu.se>, Hans Liss <hans.liss@its.uu.se>,
       "Paul E. McKenney" <paulmck@us.ibm.com>,
       Patrick McHardy <kaber@trash.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fib-trie: code cleanup
Message-ID: <20091208191731.GB1653@Krystal>
References: <20091208184839.GA31383@Krystal> <20091208110539.2b46e64b@nehalam>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20091208110539.2b46e64b@nehalam>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 14:17:18 up 6 days, 10:07,  4 users,  load average: 0.28, 0.15,
	0.10
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Stephen Hemminger (shemminger@linux-foundation.org) wrote:
> On Tue, 8 Dec 2009 13:48:39 -0500
> Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > - I moved static const that were hidden in the middle of the file to defines on
> >   top.
> 
> Keep them as static const, makeing them #define's doesn't help anything
> 

OK, but can we move them to the top of the file ?

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
