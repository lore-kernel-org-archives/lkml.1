Return-Path: <linux-kernel-owner+w=401wt.eu-S1753574AbXIPO4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574AbXIPO4W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 10:56:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752657AbXIPO4P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 10:56:15 -0400
Received: from gw.goop.org ([64.81.55.164]:42610 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752513AbXIPO4O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 10:56:14 -0400
Message-ID: <46ED440E.3020209@goop.org>
Date: Sun, 16 Sep 2007 07:56:14 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Alexey Eremenko <al4321@gmail.com>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH 2/3] Consolidate host virtualization support under	Virtualization
 menu
References: <1189747054.7262.34.camel@localhost.localdomain>	<1189747124.7262.36.camel@localhost.localdomain>	<20070914091921.73007c5a.randy.dunlap@oracle.com>	<1189825504.7262.75.camel@localhost.localdomain>	<7fac565a0709150149kf55de62q92496cf74e7b0581@mail.gmail.com> <1189928617.7262.98.camel@localhost.localdomain>
In-Reply-To: <1189928617.7262.98.camel@localhost.localdomain>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> Well, containerization deserves its own menu, but the question is does i
> it belong under this menu?

No, I don't think so.  While there are some broad similarities in
effect, the technology is completely different, as are the capabilities
and tradeoffs.  They're pretty much orthogonal.

    J
