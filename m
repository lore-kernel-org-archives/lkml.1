Return-Path: <linux-kernel-owner+w=401wt.eu-S935017AbZJOR6h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935017AbZJOR6h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 13:58:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934645AbZJOR6g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 13:58:36 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:59053 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933553AbZJOR6g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 13:58:36 -0400
X-Greylist: delayed 1012 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Oct 2009 13:58:35 EDT
Message-ID: <4AD75EA6.8080809@polymtl.ca>
Date: Thu, 15 Oct 2009 13:40:54 -0400
From: Pierre-Marc Fournier <pierre-marc.fournier@polymtl.ca>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: Josh Triplett <josh@joshtriplett.org>
CC: Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Jon Bernard <jbernard@debian.org>, Jan Blunck <jblunck@suse.de>,
       Pierre Habouzit <madcoder@debian.org>,
       Steven Munroe <munroesj@linux.vnet.ibm.com>,
       Bert Wesarg <bert.wesarg@googlemail.com>, ltt-dev@lists.casi.polymtl.ca,
       rp@svcs.cs.pdx.edu, linux-kernel@vger.kernel.org
Subject: Re: Userspace RCU 0.2.3
References: <20091014223657.GC6458@Krystal> <20091015000225.GG6763@linux.vnet.ibm.com> <20091015023925.GA27959@Krystal> <20091015090042.GA7677@feather>
In-Reply-To: <20091015090042.GA7677@feather>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Poly-FromMTA: (clnt01-230-151.vpn.polymtl.ca [132.207.230.151]) at Thu, 15 Oct 2009 17:40:55 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Josh Triplett wrote:
> 
> Even Debian has given up on real 386 systems at this point, primarily
> because system libraries like glibc have; 486 and better represents the
> bare minimum required at this point.  I don't know of any distributions
> supporting real 386 systems at this point, and doing so would represent
> a major undertaking.
> 

What about embedded systems? Anyone know if some 386 chips, perhaps even
in smp configurations, are still in use in those?
