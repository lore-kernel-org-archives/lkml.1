Return-Path: <linux-kernel-owner+w=401wt.eu-S1753216AbXIGXm4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216AbXIGXm4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 19:42:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752183AbXIGXmm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 19:42:42 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:46040 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751935AbXIGXml (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 19:42:41 -0400
Message-ID: <46E1E1EC.4000405@garzik.org>
Date: Fri, 07 Sep 2007 19:42:36 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Reyk Floeter <reyk@openbsd.org>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       jirislaby@gmail.com, moglen@softwarefreedom.org
Subject: Re: request for information about the "ath5k" licensing
References: <20070905151823.GA1384@slim.vantronix.net> <200709051835.33572.mb@bu3sch.de> <43e72e890709051000m74252604paff3eb1651f55d22@mail.gmail.com> <20070907064730.GA15001@slim.vantronix.net>
In-Reply-To: <20070907064730.GA15001@slim.vantronix.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Reyk Floeter wrote:
> I'm still waiting for an answer. Your process is taking too long.


Speaking as a person through which these changes flow upstream into the 
official kernel (ath5k maintainers -> linville -> me -> linus)...


The most important thing for today is that no ath5k stuff has been 
committed (nor has it ever been).


I would rather take it slow and make sure everybody is happy.  There is 
nothing upstream, and so, there is no need to rush and correct something.

Collectively, this is just growing pains.  Everyone is breaking new 
ground, trying to figure out how to best support atheros stuff on Linux. 
  There are new tools to deal with (svn? git? flavor of the day?:)), new 
licenses with new ramifications to consider, a new wireless stack to 
deal with.

What you are witnessing is but a small part of the chaos as everyone 
tackles these chores simultaneously.

	Jeff


