Return-Path: <linux-kernel-owner+w=401wt.eu-S1752702AbYIBPdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702AbYIBPdT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 11:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751259AbYIBPdH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 11:33:07 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:38938 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248AbYIBPdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 11:33:06 -0400
Date: Tue, 2 Sep 2008 10:32:53 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>,
       containers@lists.linux-foundation.org, jeremy@goop.org, arnd@arndb.de,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC v2][PATCH 4/9] Memory management - dump state
Message-ID: <20080902153253.GE8524@us.ibm.com>
References: <1219437422.20559.146.camel@nimitz> <48B0F449.2000006@cs.columbia.edu> <1219768406.8680.17.camel@nimitz> <48B49C61.1040003@cs.columbia.edu> <1219851696.8680.67.camel@nimitz> <20080827203427.GA1158@us.ibm.com> <1219869510.8680.90.camel@nimitz> <20080827204853.GA4189@us.ibm.com> <1219870576.8680.96.camel@nimitz> <48BA454F.7050308@cs.columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48BA454F.7050308@cs.columbia.edu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Oren Laadan (orenl@cs.columbia.edu):
>
> Dave, Serge:
>
> I'm currently away so I must keep this short. I think we have so far
> more discussion than an actual problem. I'm happy to coordinate with
> every interested party to eventually see this work go into main stream.
>
> My only concerns are twofold: first, to get more feedback I believe we
> need to get the code a bit more usable; including FDs is an excellent
> way to actually do that. That will add significant value to the patch.
> I think it's important to demonstrate how shared resources and multiple
> processes are handled. FDs demonstrate the former (with a fixed version
> of the recent patchset - I will post soon). The latter will increase
> the size of the patchset significantly, so perhaps can indeed wait for
> now.
>
> It should not be hard for me to add functionality on top of a more
> basic patchset.

Excellent.

Having two trees or branches, one very basic and nigh-upon useless, with
another advanced enough to be a valuable proof of concept to answer "oh
yeah, well how will you do (X)?", will work out best.

> The question is, what is "basic" ?

Yes that is a very good question :)

> Anyway, I will be
> back towards the end of the week. Let's try to discuss this over IRC
> then (e.g. Friday afternoon ?).

Sounds great.  (I may be taking the day off to paint, but will try to
monitor irc)

thanks,
-serge
