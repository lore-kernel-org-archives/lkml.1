Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932730Ab0BCTqc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 14:46:32 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:50709 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932160Ab0BCTq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 14:46:29 -0500
Subject: Re: [PATCH] netfilter: per netns nf_conntrack_cachep
From: Jon Masters <jonathan@jonmasters.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Patrick McHardy <kaber@trash.net>, Eric Dumazet <eric.dumazet@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>,
       netfilter-devel <netfilter-devel@vger.kernel.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <1265226227.2861.302.camel@tonnant>
References: <1265108690.2861.118.camel@tonnant>
	 <1265110504.2861.135.camel@tonnant> <1265129192.2861.141.camel@tonnant>
	 <4B685756.8010107@trash.net> <1265130426.2861.158.camel@tonnant>
	 <b6fcc0a1002020958u17315624u4d54d06a413be6bb@mail.gmail.com>
	 <1265134598.2861.191.camel@tonnant> <4B6870AF.6060109@trash.net>
	 <4B6967BC.600@trash.net> <1265222289.2861.290.camel@tonnant>
	 <20100203190948.GA5182@x200>  <1265226227.2861.302.camel@tonnant>
Content-Type: text/plain
Organization: World Organi[sz]ation of Broken Dreams
Date: Wed, 03 Feb 2010 14:46:11 -0500
Message-Id: <1265226371.2861.303.camel@tonnant>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 127.0.0.1
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-02-03 at 14:44 -0500, Jon Masters wrote:
> On Wed, 2010-02-03 at 21:09 +0200, Alexey Dobriyan wrote:
> > On Wed, Feb 03, 2010 at 01:38:09PM -0500, Jon Masters wrote:

> > > I also think it is necessary to expose net namespace layout
> > 
> > Not necessary. Why?
> 
> How am I as a sysadmin supposed to figure out which net namespaces exist
> on my system, and as a developer, supposed to debug these situations?

(without Jason's excellent kgdb patches, which really help)

Jon.


